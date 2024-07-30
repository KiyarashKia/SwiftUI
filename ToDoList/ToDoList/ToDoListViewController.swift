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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register a standard cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoItemCell")
        
        // Load existing to-do items
        loadToDoItems()
        
        navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(markAsDone(_:)), for: .touchUpInside)
        doneButton.tag = indexPath.row
        cell.accessoryView = doneButton
        
        return cell
    }
    
    @objc func markAsDone(_ sender: UIButton) {
        let index = sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        
        // Mark the item visually as done (e.g., change text color to gray)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .gray
        
        // Delay removal
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            self.toDoItems.remove(at: index)
            self.saveToDoItems()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the item from the array
            toDoItems.remove(at: indexPath.row)
            
            // Save the updated array to UserDefaults
            saveToDoItems()
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
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
