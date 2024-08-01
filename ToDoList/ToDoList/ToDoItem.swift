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
    var imageData: Data?
    
    var isExpanded: Bool = false
    var isDone: Bool = false
    
    init(title: String, description: String, dueDate: Date, imageData: Data? = nil) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.imageData = imageData
    }
    
}
