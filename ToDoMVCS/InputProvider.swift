//
//  InputProvider.swift
//  ToDoMVCS
//
//  Created by DianQK on 2018/5/18.
//  Copyright © 2018 DianQK. All rights reserved.
//

import UIKit
import Flix

class InputProvider: SingleUITableViewCellProvider {

    let textField = UITextField()

    override init() {
        super.init()
        self.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        textField.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }

}
