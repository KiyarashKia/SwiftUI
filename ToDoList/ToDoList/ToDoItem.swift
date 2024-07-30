//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Kiarash Kiya on 2024-07-29.
//

import Foundation

class ToDoItem: Codable {
    var title: String
    var description: String
    var dueDate: Date
    
    init(title: String, description: String, dueDate: Date) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
    }
    
}
