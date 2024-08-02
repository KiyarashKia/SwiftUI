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
    
    // Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        loadToDoItems()
        
        if !UserDefaults.standard.bool(forKey: "shouldShowGuidingAlert") {
            showGuidingAlert()
        } else if toDoItems.isEmpty {
            showNoItemsAlert()
        }
    }
    
    // MARK: - View Setup
    func setupView() {
        // Register a standard cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoItemCell")
        
        // Configuring table view's height of row
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    
        
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
        
        // Initially hide the activity indicator
        activityIndicator.isHidden = true
    }
    
    // MARK: - Sorting
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
        
        // Create the menu and returning it
        return UIMenu(title: "Sort by", children: [sortByTitleAction, sortByDateAction])
    }
    
    
    func showGuidingAlert() {
        let alert = UIAlertController(title: "How to Use", message: "To delete an item, swipe left. To mark an item as done, swipe right. And to see the image, hold on the thumbnail", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Got it", style: .default) { _ in
            UserDefaults.standard.set(true, forKey: "shouldShowGuidingAlert") // Don't show again
            if self.toDoItems.isEmpty {
                self.showNoItemsAlert()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
    
    // MARK: - Button Actions
    
    // Toggle editing mode
    @objc func editButtonTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItems?[0].title = tableView.isEditing ? "Done" : "Edit"
    }
    
    // Share button action
    @objc func shareButtonTapped(_ sender: UIButton) {
        // Find the index path of the cell containing the button
        guard let cell = sender.superview?.superview as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }

        let item = toDoItems[indexPath.row]
        let shareText = "Title: \(item.title)\nDue: \(formattedDate(item.dueDate))\nDescription: \(item.description)"
        
        var itemsToShare: [Any] = [shareText]
        
        // If there's an image, add it to the items to share
        if let imageData = item.imageData, let image = UIImage(data: imageData) {
            itemsToShare.append(image)
        }
        
        // Sharing section
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
       
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - TableView Data Source
    
    // Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    // Configure cell at indexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse or create a UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = toDoItems[indexPath.row]

        // Remove any existing subviews in case the cell is being reused
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        // Title Label (always visible)
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.text = item.title
        titleLabel.numberOfLines = 0
        
        // Create and configure the stack view for expanded content
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4

        // Update the cell's appearance based on whether the item is done
        if item.isDone {
            cell.contentView.backgroundColor = .lightGray
            titleLabel.textColor = .white
        } else {
            cell.contentView.backgroundColor = .white
            titleLabel.textColor = .black
        }

        // Just to call to add space - empty line
        func createSpacer(height: CGFloat = 8) -> UIView {
            let spacer = UIView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
            return spacer
        }

        // If expanded, add additional content for each row
        if item.isExpanded {
            let separatorLine = UIView()
            separatorLine.backgroundColor = .lightGray
            separatorLine.translatesAutoresizingMaskIntoConstraints = false
            separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

            let titleLabel2 = UILabel()
            titleLabel2.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            titleLabel2.text = "Title: \(item.title)"
            titleLabel2.numberOfLines = 0

            let dueDateLabel = UILabel()
            dueDateLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            dueDateLabel.text = "Due: \(formattedDate(item.dueDate))"
            dueDateLabel.numberOfLines = 0

            let descriptionLabel = UILabel()
            descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = "Description: \(item.description)"

            // Configure the image view for each list
            let imageView = UIImageView()
            imageView.removeConstraints(imageView.constraints)
            
            if let imageData = item.imageData {
                imageView.image = UIImage(data: imageData)
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 15
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.isHidden = false

                
                stackView.addArrangedSubview(descriptionLabel)
                stackView.addArrangedSubview(imageView)
                
                // Apply constraints to ensure imageView is always below descriptionLabel
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor), // Align to the left edge of the stack view
                    imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8), // Position just below the descriptionLabel
                    imageView.widthAnchor.constraint(equalToConstant: 50), // Width of 50 points
                    imageView.heightAnchor.constraint(equalToConstant: 50) // Height of 50 points
                ])
                
                // Add a long press gesture recognizer for image expansion
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(longPressGesture)
            } else {
                imageView.image = nil
                imageView.isHidden = true // Hide the image view if there's no image
                stackView.addArrangedSubview(descriptionLabel) // Just add the descriptionLabel without the image
            }

            stackView.addArrangedSubview(separatorLine)
            stackView.addArrangedSubview(createSpacer())
            stackView.addArrangedSubview(titleLabel2)
            stackView.addArrangedSubview(dueDateLabel)
            stackView.addArrangedSubview(createSpacer())
            stackView.addArrangedSubview(descriptionLabel)
            stackView.addArrangedSubview(createSpacer())
            stackView.addArrangedSubview(createSpacer())
            stackView.addArrangedSubview(createSpacer())
            stackView.addArrangedSubview(createSpacer())
            stackView.addArrangedSubview(createSpacer())
            stackView.addArrangedSubview(imageView)
            
        }
        
        // Align items to the leading edge (left side)
        stackView.alignment = .leading
       
        
        // Add the stack view to the cell's content view
        cell.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
        ])
        
        

        // Add the share button directly to the contentView, outside of the stack view
        if item.isExpanded {
            let shareButton = UIButton(type: .system)
            shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            shareButton.tintColor = .systemYellow
            shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)

            cell.contentView.addSubview(shareButton)
            shareButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                shareButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                shareButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -6),
                shareButton.heightAnchor.constraint(equalToConstant: 30),
                shareButton.widthAnchor.constraint(equalToConstant: 30)
            ])
        }

        // Add a chevron indicating expandable state
        let chevron = UIImageView(image: UIImage(systemName: item.isExpanded ? "chevron.up" : "chevron.down"))
        chevron.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(chevron)
        NSLayoutConstraint.activate([
            chevron.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            chevron.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            chevron.heightAnchor.constraint(equalToConstant: 20),
            chevron.widthAnchor.constraint(equalToConstant: 20)
        ])

        return cell
    }
    
    // MARK: - TableView Delegate
    
    // Toggle expanded state
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoItems[indexPath.row].isExpanded.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    
    // Formats a Date object into a string
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    
    // Configure swipe actions for deletion
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
    
    
    // Configure swipe actions for marking as done
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
    
    // MARK: - Mark Item as Done
    
    // Function to mark an item as done
    func markItemAsDone(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        // Create an overlay view that covers the entire cell content
        let overlayView = UIView()
        overlayView.backgroundColor = .lightGray
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        let doneLabel = UILabel()
        doneLabel.text = " Done and Disappearing.."
        doneLabel.textColor = .white
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        doneLabel.textAlignment = .left

        overlayView.addSubview(doneLabel)
        cell.contentView.addSubview(overlayView)

        // Constraints for overlay and done label
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),

            doneLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])

        // Add an "Undo" button
        let undoButton = UIButton(type: .system)
            undoButton.setTitle("Undo", for: .normal)
            undoButton.setTitleColor(.white, for: .normal)
            undoButton.backgroundColor = .systemRed
            undoButton.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
            undoButton.frame = CGRect(x: cell.contentView.frame.width - 70, y: 0, width: 70, height: cell.contentView.frame.height)

            // Ensure the "Undo" button appears above all other subviews
            cell.contentView.addSubview(undoButton)
            cell.contentView.bringSubviewToFront(undoButton)

            activityIndicator.isHidden = false

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
    


    // Undo item deletion
    func undoItem(at indexPath: IndexPath) {
        // Cancel the removal work item
        removalWorkItems[indexPath]?.cancel()
        removalWorkItems[indexPath] = nil

        // Restore the item state
        toDoItems[indexPath.row].isDone = false

        // Restore the appearance of the cell
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = toDoItems[indexPath.row]

            // To ensure resetting and removing elements after
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.textLabel?.text = nil

            
            // Rebuild the cell's UI as it was before the item was marked as done
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            titleLabel.text = item.title
            titleLabel.numberOfLines = 0

            let titleLabel2 = UILabel()
            titleLabel2.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            titleLabel2.text = "Title: \(item.title)"
            titleLabel2.numberOfLines = 0

            let dueDateLabel = UILabel()
            dueDateLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            dueDateLabel.text = "Due: \(formattedDate(item.dueDate))"
            dueDateLabel.numberOfLines = 0

            let descriptionLabel = UILabel()
            descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = "Description: \(item.description)"

            let separatorLine = UIView()
            separatorLine.backgroundColor = .lightGray
            separatorLine.translatesAutoresizingMaskIntoConstraints = false
            separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

            let stackView = UIStackView(arrangedSubviews: [titleLabel])
            stackView.axis = .vertical
            stackView.spacing = 4

            func createSpacer(height: CGFloat = 8) -> UIView {
                let spacer = UIView()
                spacer.translatesAutoresizingMaskIntoConstraints = false
                spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
                return spacer
            }

            if item.isExpanded {
                stackView.addArrangedSubview(separatorLine)
                stackView.addArrangedSubview(createSpacer())
                stackView.addArrangedSubview(titleLabel2)
                stackView.addArrangedSubview(dueDateLabel)
                stackView.addArrangedSubview(createSpacer())
                stackView.addArrangedSubview(descriptionLabel)
            }

            cell.contentView.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
            ])

            // Add a chevron indicating expandable state
                  let chevron = UIImageView(image: UIImage(systemName: item.isExpanded ? "chevron.up" : "chevron.down"))
                  cell.accessoryView = chevron

            // Restore the background color and any other temporary changes
            cell.contentView.backgroundColor = .white
            activityIndicator.isHidden = true
        }
    }
        
    
    @objc func undoButtonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            undoItem(at: indexPath)
        }
    }
    
    // MARK: - Save/Load Items
    
    // Save items to UserDefaults
    func saveToDoItems() {
        if let encodedData = try? JSONEncoder().encode(toDoItems) {
            UserDefaults.standard.set(encodedData, forKey: "toDoItems")
        }
    }
    
    // Load items from UserDefaults
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
       
    // Handles long-press gesture to show an image full-screen
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let imageView = gesture.view as? UIImageView, let image = imageView.image else { return }
            
            // Create a full-screen image view
            let fullScreenImageView = UIImageView(image: image)
            fullScreenImageView.frame = UIScreen.main.bounds  // Set to full screen size
            fullScreenImageView.backgroundColor = .black
            fullScreenImageView.contentMode = .scaleAspectFit
            fullScreenImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            fullScreenImageView.isUserInteractionEnabled = true
            
            // Add a tap gesture to dismiss the full-screen image
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage(_:)))
            fullScreenImageView.addGestureRecognizer(tapGesture)
            
            // Get the current active window in iOS 13 and later
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(fullScreenImageView)
                keyWindow.bringSubviewToFront(fullScreenImageView)
            } else {
                // Fallback for earlier iOS versions
                self.view.addSubview(fullScreenImageView)
                self.view.bringSubviewToFront(fullScreenImageView)
            }
            
            // Animate the appearance of the full-screen image view
            fullScreenImageView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                fullScreenImageView.alpha = 1.0
            }
        }
    }


    // Dismisses the full-screen image on tap
    @objc func dismissFullScreenImage(_ gesture: UITapGestureRecognizer) {
        // Animate the dismissal of the full-screen image view
        UIView.animate(withDuration: 0.3, animations: {
            gesture.view?.alpha = 0
        }) { _ in
            gesture.view?.removeFromSuperview()
        }
    }
    
}

