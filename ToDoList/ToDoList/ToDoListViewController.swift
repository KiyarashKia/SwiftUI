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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Register a standard cell
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoItemCell")
            
            // Add an Edit button to the navigation bar
            navigationItem.rightBarButtonItem = self.editButtonItem
        activityIndicator.isHidden = true
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
            // Create the "Delete" action
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                self.toDoItems.remove(at: indexPath.row)
                self.saveToDoItems()
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            }
            
            
            // Return the swipe actions
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
            _ = toDoItems[indexPath.row]
            
            // Temporarily change the appearance of the cell to indicate it's done
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.contentView.backgroundColor = .lightGray
                cell.textLabel?.text = "Done and Disappearing.."
                cell.textLabel?.textColor = .white
                activityIndicator.isHidden = false
            }

            // Show the activity indicator
            activityIndicator.startAnimating()
            
            // Delay removal of the item
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.toDoItems.remove(at: indexPath.row)
                self.saveToDoItems()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Hide the activity indicator
                self.activityIndicator.stopAnimating()
                
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
    }
