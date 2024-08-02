//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Kiarash Kiya on 2024-08-01.
//

import Foundation
import UIKit

class ToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    
}


// - Explanation:
//This is the  class just to avoid the error of using imageView in repeating form of table view as it did not let me make it. Surely there is a way to fix it, but for now I keep as it is because another reason which is scaling what I have in each row in future.
