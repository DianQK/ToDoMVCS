//
//  ViewController.swift
//  ToDoMVCS
//
//  Created by DianQK on 2018/5/18.
//  Copyright © 2018 DianQK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderHeight = .leastNonzeroMagnitude

        let inputProvider = InputProvider()
        inputProvider.textField.placeholder = "Adding a new item..."
        let title = inputProvider.textField.rx
            .controlProperty(editingEvents: .editingDidEndOnExit, getter: { $0.text }, setter: { $0.text = $1 })
            .orEmpty
            .changed
            .filter { !$0.isEmpty }

        title.asObservable()
            .subscribe(onNext: { (title) in
                inputProvider.textField.text = ""
                ToDoStore.shared.add(title: title)
            })
            .disposed(by: disposeBag)

        tableView.flix.animatable.build([
            TodoListProvider(),
            inputProvider
            ])

        ToDoStore.shared.count.map { "TODO - (\($0))" }.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
    }

}
