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
    let descriptionPlaceholder = "What are you going to do on that day?"
    var toDoItems: [ToDoItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update the top label with the list number
        listNumberLabel.text = "List \(listNumber)"
        
        // Set up the description view
        descriptionView.delegate = self
        descriptionView.text = descriptionPlaceholder
        descriptionView.textColor = .lightGray
        
        // Load existing to-do items
        loadToDoItems()
        
        // Disable the save button initially
        saveButton.isEnabled = false
        
        // Add target to monitor text changes in the title field
        titleField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Enable save button if the title field is not empty
        let title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        saveButton.isEnabled = !title.isEmpty
    }
    
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == descriptionPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }

    // UITextViewDelegate method
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    @IBAction func saveReminder(_ sender: UIButton) {
        let title = titleField.text ?? ""
        let description = descriptionView.text ?? ""
        let dueDate = datePicker.date


        if title.isEmpty {
               showAlert(message: "The title field is required. Please enter a title.")
               return
           }
           
           // Continue with saving the reminder if title is filled
           let newItem = ToDoItem(title: title, description: description, dueDate: dueDate)
           toDoItems.append(newItem)
           saveToDoItems()
           performSegue(withIdentifier: "unwindToMainMenu", sender: self)
       }

       func showAlert(message: String) {
           let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
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
