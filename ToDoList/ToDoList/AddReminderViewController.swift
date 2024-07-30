//
//  AddReminderViewController.swift
//  ToDoList
//
//  Created by Kiarash Kiya on 2024-07-29.
//

import Foundation
import UIKit

class AddReminderViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var listNumberLabel: UILabel!

    var listNumber: Int = 1
    let placeholderText = "What are you going to do on that day?"
    var toDoItems: [ToDoItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Update the top label with the list number
        listNumberLabel.text = "List \(listNumber)"
        
        descriptionView.delegate = self
        
        descriptionView.text = placeholderText
        descriptionView.textColor = .lightGray
        
        loadToDoItems()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }

    // UITextViewDelegate method
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
    
    @IBAction func saveReminder(_ sender: UIButton) {
        let title = titleField.text ?? ""
        let description = descriptionView.text ?? ""
        let dueDate = datePicker.date


        let newItem = ToDoItem(title: title, description: description, dueDate: dueDate)
        
        toDoItems.append(newItem)
        
        // Save the array to UserDefaults
        saveToDoItems()
        
        print("Title: \(title), Description: \(description), Due Date: \(dueDate)")

        // Optionally, pass data back to the previous view controller or save it in a data model

        // Dismiss the view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveToDoItems() {
        // Convert the array to Data
        if let encodedData = try? JSONEncoder().encode(toDoItems) {
            UserDefaults.standard.set(encodedData, forKey: "toDoItems")
        }
    }

    func loadToDoItems() {
        if let savedData = UserDefaults.standard.data(forKey: "toDoItems"),
           let decodedItems = try? JSONDecoder().decode([ToDoItem].self, from: savedData) {
            toDoItems = decodedItems
        }
    }
    
}
