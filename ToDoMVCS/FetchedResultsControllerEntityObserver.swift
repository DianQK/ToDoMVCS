//
//  FetchedResultsControllerEntityObserver.swift
//  ToDoMVCS
//
//  Created by DianQK on 2018/5/18.
//  Copyright © 2018 DianQK. All rights reserved.
//


import Foundation
import CoreData
import RxSwift
import RxCocoa

public final class FetchedResultsControllerEntityObserver<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {

    typealias Observer = AnyObserver<[T]>

    fileprivate let observer: Observer
    fileprivate let disposeBag = DisposeBag()
    fileprivate let frc: NSFetchedResultsController<T>


    init(observer: Observer, fetchRequest: NSFetchRequest<T>, managedObjectContext context: NSManagedObjectContext, sectionNameKeyPath: String?, cacheName: String?) {
        self.observer = observer

        self.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
        super.init()

        context.perform {
            self.frc.delegate = self

            do {
                try self.frc.performFetch()
            } catch let e {
                observer.on(.error(e))
            }

            self.sendNextElement()
        }
    }

    fileprivate func sendNextElement() {
        self.frc.managedObjectContext.perform { [weak self] in
            guard let `self` = self else { return }
            let entities = self.frc.fetchedObjects ?? []
            self.observer.on(.next(entities))
        }
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sendNextElement()
    }
}

extension FetchedResultsControllerEntityObserver: Disposable {

    public func dispose() {
        frc.delegate = nil
    }

}

public extension Reactive where Base: NSManagedObjectContext {

    /**
     Executes a fetch request and returns the fetched objects as an `Observable` array of `NSManagedObjects`.
     - parameter fetchRequest: an instance of `NSFetchRequest` to describe the search criteria used to retrieve data from a persistent store
     - parameter sectionNameKeyPath: the key path on the fetched objects used to determine the section they belong to; defaults to `nil`
     - parameter cacheName: the name of the file used to cache section information; defaults to `nil`
     - returns: An `Observable` array of `NSManagedObjects` objects that can be bound to a table view.
     */
    func entities<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>,
                                      sectionNameKeyPath: String? = nil,
                                      cacheName: String? = nil) -> Observable<[T]> {
        return Observable.create { observer in

            let observerAdapter = FetchedResultsControllerEntityObserver(observer: observer, fetchRequest: fetchRequest, managedObjectContext: self.base, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)

            return Disposables.create {
                observerAdapter.dispose()
            }
        }
    }

}

