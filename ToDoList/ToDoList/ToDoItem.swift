//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Kiarash Kiya on 2024-07-29.
//

import Foundation

// Represents a to-do item with title, description, due date, and optional image data
class ToDoItem: Codable {
    var id: UUID = UUID()
    var title: String       // The title of the to-do item
    var description: String // A brief description of the to-do item
    var dueDate: Date       // The due date for the to-do item
    var imageData: Data?    // Optional image data associated with the to-do item
    
    var isExpanded: Bool = false // Tracks whether the item is expanded in the UI
    var isDone: Bool = false     // Tracks whether the item is marked as done
    
    // Initializes a new to-do item with the provided title, description, due date, and optional image data
    init(title: String, description: String, dueDate: Date, imageData: Data? = nil) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.imageData = imageData
    }
}
