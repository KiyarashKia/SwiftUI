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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Actions for buttons
    @IBAction func viewListsTapped(_ sender: UIButton) {
        // Code to show existing lists
    }

    @IBAction func createNewListTapped(_ sender: UIButton) {
        // Code to show the new list creation screen
    }
}
