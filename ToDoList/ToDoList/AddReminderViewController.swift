//
//  AddReminderViewController.swift
//  ToDoList
//
//  Created by Kiarash Kiya on 2024-07-29.
//

import Foundation
import UIKit

class AddReminderViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Outlets and variables
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var listNumberLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var attachButton: UIButton!
    
    
    
    
    var listNumber: Int = 1 // Tracks the current list number
    
    // Placeholder text for the description field
    let descriptionPlaceholder = "What are you going to do on that day?"
    var toDoItems: [ToDoItem] = [] // Array to hold to-do items/
    
    // MARK: - View
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
        
        // Add a long press gesture recognizer to the image view
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
           imageView.addGestureRecognizer(longPressGesture)
           imageView.isUserInteractionEnabled = true
    }
    
    
    // MARK: - Text Field and Text View
    
    // Enable save button if the title field is not empty
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Enable save button if the title field is not empty
        let title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        saveButton.isEnabled = !title.isEmpty
    }
    
    
    // Clear placeholder text when editing begins
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == descriptionPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    // Restore placeholder text if description is empty
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    // MARK: - Save Reminder
    @IBAction func saveReminder(_ sender: UIButton) {
        // Capture input data
        let title = titleField.text ?? ""
        let description = descriptionView.text ?? ""
        let dueDate = datePicker.date
        
        // Convert selected image to data if available
        let selectedImage = imageView.image
        let imageData = selectedImage?.jpegData(compressionQuality: 1.0)
          
        // Create and save a new to-do item
        let newItem = ToDoItem(title: title, description: description, dueDate: dueDate, imageData: imageData)
            toDoItems.append(newItem)
            saveToDoItems()

        // Segue back to the main menu
        performSegue(withIdentifier: "unwindToMainMenu", sender: self)
        }
    
    
    // Save the to-do items to UserDefaults
    func saveToDoItems() {
        // Convert the array to Data
        if let encodedData = try? JSONEncoder().encode(toDoItems) {
            UserDefaults.standard.set(encodedData, forKey: "toDoItems")
        }
    }
    
    
    // Load the to-do items from UserDefaults
    func loadToDoItems() {
        if let savedData = UserDefaults.standard.data(forKey: "toDoItems"),
           let decodedItems = try? JSONDecoder().decode([ToDoItem].self, from: savedData) {
            toDoItems = decodedItems
        }
    }
    
    // MARK: - Image Attachment
    
    @IBAction func attachImage(_ sender: UIButton) {
        // Open the photo library to select an image
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Handle image selection from the photo library
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Handle cancellation of image picker
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Full-Screen Image Handling
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let image = imageView.image else { return }

            // Create a full-screen view
            let fullScreenView = UIView(frame: self.view.bounds)
            fullScreenView.backgroundColor = .black
            fullScreenView.alpha = 0.0
            
            // Create a UIImageView for the full-screen image
            let fullScreenImageView = UIImageView(image: image)
            fullScreenImageView.contentMode = .scaleAspectFit
            fullScreenImageView.frame = fullScreenView.bounds
            fullScreenView.addSubview(fullScreenImageView)
            
            // Add a tap gesture recognizer to dismiss the full-screen view
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage(_:)))
            fullScreenView.addGestureRecognizer(tapGesture)
            
            // Add the full-screen view to the current view
            self.view.addSubview(fullScreenView)
            
            // Animate the appearance of the full-screen view
            UIView.animate(withDuration: 0.3) {
                fullScreenView.alpha = 1.0
            }
        }
    }

    // Dismiss the full-screen image view on tap
    @objc func dismissFullScreenImage(_ gesture: UITapGestureRecognizer) {
        // Animate the dismissal of the full-screen view
        UIView.animate(withDuration: 0.3, animations: {
            gesture.view?.alpha = 0.0
        }) { _ in
            // Remove the full-screen view from the hierarchy
            gesture.view?.removeFromSuperview()
        }
    }
    
}
