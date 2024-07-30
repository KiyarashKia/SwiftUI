//
//  MainMenuViewController.swift
//  ToDoList
//
//  Created by Kiarash Kiya on 2024-07-27.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    // Outlets for buttons
    @IBOutlet weak var viewListsButton: UIButton!
    @IBOutlet weak var createNewListButton: UIButton!

    var nextListNumber: Int = 1 // You should replace this with actual logic to determine the next list number

    var toDoItems: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToDoItems()
    }

    // Actions for buttons
    @IBAction func viewListsTapped(_ sender: UIButton) {
        loadToDoItems()
        performSegue(withIdentifier: "showToDoList", sender: self)
    }

    @IBAction func createNewListTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "AddReminderViewController", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddReminderViewController" {
                   if let destinationVC = segue.destination as? AddReminderViewController {
                       destinationVC.listNumber = nextListNumber
                       nextListNumber += 1
                       destinationVC.toDoItems = toDoItems
                   }
               } else if segue.identifier == "showToDoList" {
                   if let destinationVC = segue.destination as? ToDoListViewController {
                       destinationVC.toDoItems = toDoItems
                   }
               }
           }
    
    func loadToDoItems() {
            if let savedData = UserDefaults.standard.data(forKey: "toDoItems"),
               let decodedItems = try? JSONDecoder().decode([ToDoItem].self, from: savedData) {
                toDoItems = decodedItems
            }
        }
}

