//
//  TodoListProvider.swift
//  ToDoMVCS
//
//  Created by DianQK on 2018/5/18.
//  Copyright © 2018 DianQK. All rights reserved.
//

import UIKit
import Flix
import RxSwift

extension Todo: StringIdentifiableType {

    public var identity: String {
        return self.objectID.uriRepresentation().absoluteString
    }

}

class TodoListProvider: AnimatableTableViewProvider {

    func configureCell(_ tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath, value: Todo) {
        cell.textLabel?.text = value.title
        cell.selectionStyle = .none
    }

    func createValues() -> Observable<[Todo]> {
        return ToDoStore.shared.todoList
    }

    typealias Value = Todo
    typealias Cell = UITableViewCell

}

extension TodoListProvider: TableViewDeleteable {

    func tableView(_ tableView: UITableView, itemDeletedForRowAt indexPath: IndexPath, value: Todo) {
        ToDoStore.shared.delete(todo: value)
    }

}
