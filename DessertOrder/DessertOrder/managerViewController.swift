//
//  managerViewController.swift
//  DessertOrder
//
//  Created by Kiarash Kiya on 2024-07-06.
//

import Foundation
import UIKit

class ManagerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Outlets
    @IBOutlet weak var bb: UIButton!
    @IBOutlet weak var fLabel: UILabel!
    @IBOutlet weak var loManager: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var donutImageView: UIImageView!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var stockStepper: UIStepper!
    @IBOutlet weak var saveButton: UIButton!

    var store: Store!   // Ref to the store
        var purchases: [Purchase] = []      // list of purchases

        override func viewDidLoad() {
            super.viewDidLoad()

            pickerView.delegate = self
            pickerView.dataSource = self

            stockStepper.minimumValue = 1
            stockStepper.stepValue = 1

            // Hide controls until login
            toggleManagerControls(isHidden: true)
            fLabel.isHidden = true
        }

    // Login action button
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //  Successful login
          if usernameTextField.text == "admin" && passwordTextField.text == "admin" {
              toggleManagerControls(isHidden: false)
              usernameTextField.isHidden = true
              passwordTextField.isHidden = true
              loginButton.isHidden = true
              loManager.isHidden = true
              fLabel.isHidden = false
          } else {
              // Unsuccessful
              let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              present(alert, animated: true, completion: nil)
          }
      }
        // Toggle visibility of manager controls
        func toggleManagerControls(isHidden: Bool) {
            pickerView.isHidden = isHidden
            donutImageView.isHidden = isHidden
            stockLabel.isHidden = isHidden
            stockStepper.isHidden = isHidden
            saveButton.isHidden = isHidden
        }
    
        // Stepper value changed action
        @IBAction func stepperValueChanged(_ sender: UIStepper) {
            stockLabel.text = "\(Int(stockStepper.value))"
        }

        // Save button action
        @IBAction func saveButtonPressed(_ sender: UIButton) {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            store.donuts[selectedRow].availabilityCount = Int(stockStepper.value)

            let alert = UIAlertController(title: "Success", message: "Stock updated successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        // MARK: - UIPickerViewDataSource

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return store.donuts.count
        }

        // MARK: - UIPickerViewDelegate

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return store.donuts[row].title
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedDonut = store.donuts[row]

            // Update image view and stock label
            donutImageView.image = UIImage(named: selectedDonut.imageName)
            stockStepper.value = Double(selectedDonut.availabilityCount)
            stockLabel.text = "\(selectedDonut.availabilityCount)"

            // Show controls now that a donut is selected
            toggleManagerControls(isHidden: false)
        }

    
    // Back button action
    @IBAction func bbPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

