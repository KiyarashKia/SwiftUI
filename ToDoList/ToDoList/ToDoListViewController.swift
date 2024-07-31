//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Kiarash Kiya on 2024-07-29.
//

import Foundation
import UIKit

class ToDoListViewController: UITableViewController {
    var toDoItems: [ToDoItem] = []
    var removalWorkItems: [IndexPath: DispatchWorkItem] = [:]
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register a standard cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoItemCell")
        
        showGuidingAlert()
        
        // Add an Edit button to the navigation bar
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
          
          // Create the sort button
          let sortButton = UIButton(type: .system)
          sortButton.setTitle("Sort", for: .normal)
          sortButton.showsMenuAsPrimaryAction = true // Enable dropdown
          sortButton.menu = createSortMenu() // Attach the menu
          
          // Add the sort button to the navigation bar
          let sortBarButtonItem = UIBarButtonItem(customView: sortButton)
          navigationItem.leftBarButtonItems = [sortBarButtonItem]
          navigationItem.rightBarButtonItem = editButton
        
        activityIndicator.isHidden = true
        
        loadToDoItems()
        
        if toDoItems.isEmpty {
            showNoItemsAlert()
        }
    }
    
    
    func createSortMenu() -> UIMenu {
        // Create actions for sorting
        let sortByTitleAction = UIAction(title: "Title", image: nil) { _ in
            self.toDoItems.sort { $0.title.lowercased() < $1.title.lowercased() }
            self.tableView.reloadData()
            self.saveToDoItems()
        }
        
        let sortByDateAction = UIAction(title: "Date", image: nil) { _ in
            self.toDoItems.sort { $0.dueDate < $1.dueDate }
            self.tableView.reloadData()
            self.saveToDoItems()
        }
        
        // Create the menu
        let menu = UIMenu(title: "Sort by", children: [sortByTitleAction, sortByDateAction])
        
        return menu
    }
    
    @objc func editButtonTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItems?[0].title = tableView.isEditing ? "Done" : "Edit"
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = toDoItems[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dueDateString = dateFormatter.string(from: item.dueDate)
        cell.textLabel?.text = "\(item.title) - \(dueDateString)"
        return cell
    }
    
    // Enable swipe to delete on the trailing side
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.toDoItems.remove(at: indexPath.row)
            self.saveToDoItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
            
            // Check if the list is empty and show an alert if it is
            if self.toDoItems.isEmpty {
                self.showNoItemsAlert()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Add a swipe action for marking items as done on the leading side
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create the "Done" action
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, completionHandler) in
            self.markItemAsDone(at: indexPath)
            completionHandler(true)
        }
        doneAction.backgroundColor = .blue
        
        // Return the swipe actions
        return UISwipeActionsConfiguration(actions: [doneAction])
        
    }
    
    // Function to mark an item as done
    func markItemAsDone(at indexPath: IndexPath) {
        
        // Temporarily change the appearance of the cell to indicate it's done
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .lightGray
            cell.textLabel?.text = "Done and Disappearing.."
            cell.textLabel?.textColor = .white
            
            // Add an "Undo" button
            let undoButton = UIButton(type: .system)
            undoButton.setTitle("Undo", for: .normal)
            undoButton.setTitleColor(.white, for: .normal)
            undoButton.backgroundColor = .systemRed
            undoButton.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
            undoButton.frame = CGRect(x: cell.contentView.frame.width - 60, y: 0, width: 70, height: cell.contentView.frame.height)
            cell.contentView.addSubview(undoButton)
            
            activityIndicator.isHidden = false
        }
        
        // Show the activity indicator
        activityIndicator.startAnimating()
        
        // Create a DispatchWorkItem to remove the item after a delay
        let removalWorkItem = DispatchWorkItem {
            self.toDoItems.remove(at: indexPath.row)
            self.saveToDoItems()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Hide the activity indicator
            self.activityIndicator.stopAnimating()
            
            if self.toDoItems.isEmpty {
                self.showNoItemsAlert()
            }
        }
        
        // Store the work item so it can be canceled if needed
        removalWorkItems[indexPath] = removalWorkItem
        
        // Delay removal of the item
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: removalWorkItem)
    }
    
    @objc func undoButtonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            undoItem(at: indexPath)
        }
    }
    
    func undoItem(at indexPath: IndexPath) {
        // Cancel the removal work item
        removalWorkItems[indexPath]?.cancel()
        removalWorkItems[indexPath] = nil
        
        // Restore the appearance of the cell
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = toDoItems[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let dueDateString = dateFormatter.string(from: item.dueDate)
            cell.contentView.backgroundColor = .white
            cell.textLabel?.text = "\(item.title) - \(dueDateString)"
            cell.textLabel?.textColor = .black
            
            // Remove the "Undo" button
            for subview in cell.contentView.subviews where subview is UIButton {
                subview.removeFromSuperview()
            }
            activityIndicator.isHidden = true
        }
        
    }
    func saveToDoItems() {
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
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(movedItem, at: destinationIndexPath.row)
        saveToDoItems()
    }
    
    // Enable editing mode for rows
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Enable deleting rows in editing mode
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoItems.remove(at: indexPath.row)
            saveToDoItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func showNoItemsAlert() {
        let alert = UIAlertController(title: "No Items", message: "You have no items in your to-do list. Would you like to create a new one?", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            self.performSegue(withIdentifier: "AddReminderViewController2", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showGuidingAlert() {
        if !UserDefaults.standard.bool(forKey: "hasShownGuidingAlert") {
                let alert = UIAlertController(title: "How to Use", message: "To delete an item, swipe left. To mark an item as done, swipe right.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Got it", style: .default) { _ in
                    UserDefaults.standard.set(true, forKey: "hasShownGuidingAlert")
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        }
       

}

