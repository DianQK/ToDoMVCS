//
//  TodoStore.swift
//  ToDoMVCS
//
//  Created by DianQK on 2018/5/18.
//  Copyright © 2018 DianQK. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

struct ToDoStore {

    private init() {}

    static let shared = ToDoStore()

    var todoList: Observable<[Todo]> {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Todo.createdDate, ascending: false)]
        return PersistentManager.persistentContainer.viewContext.rx.entities(fetchRequest: fetchRequest)
    }

    var count: Observable<Int> {
        return todoList.map { $0.count }
    }

    @discardableResult func add(title: String) -> Todo {
        let todo = Todo(entity: Todo.entity(), insertInto: PersistentManager.persistentContainer.viewContext)
        todo.title = title
        todo.createdDate = Date()
        PersistentManager.saveContext()
        return todo
    }

    func delete(todo: Todo) {
        PersistentManager.persistentContainer.viewContext.delete(todo)
        PersistentManager.saveContext()
    }

}
