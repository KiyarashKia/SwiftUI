//
//  ViewController.swift
//  DessertOrder
//
//  Created by Kiarash Kiya on 2024-07-05.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    struct DefaultImage {
        static let imageName = "choose.png"
    }

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectedProductLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceTag: UILabel!
    @IBAction func buyButton(_ sender: Any) {
    }
    
    
    let store = Store()
    
    var selectedDonut: Donut?
    var selectedQuantity: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        updateSelectedProductLabel()
        updateProductImageView()
        updatePriceLabel()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // Number of rows in each component of the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            // First component shows the list of donuts
            return store.donuts.count
        } else {
            // Second component shows the available stock for the selected donut
            return selectedDonut?.availabilityCount ?? 0
        }
    }
    
    // Title for each row in the picker view components
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            // First component shows the donut titles
            return store.donuts[row].title
        } else {
            // Second component shows the stock numbers (1, 2, 3, ...)
            return "\(row + 1)"
        }
    }
    
    // Called when the user selects a row in the picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // Update the selected donut and refresh the second component
            selectedDonut = store.donuts[row]
            pickerView.reloadComponent(1)
            // Update the UI to reflect the new selection
            updateSelectedProductLabel()
            updateProductImageView()
            updatePriceLabel()
        } else {
            // Update the selected quantity
            selectedQuantity = row + 1
            // Update the price label to reflect the new quantity
            updatePriceLabel()
        }
    }
    
    // Update the label to show the selected product's name
    func updateSelectedProductLabel() {
        if let selectedDonut = selectedDonut {
            selectedProductLabel.text = "\(selectedDonut.title)"
        } else {
            selectedProductLabel.text = "Select a product"
        }
    }
    
    // Update the image view to show the selected product's image
    func updateProductImageView() {
        if let selectedDonut = selectedDonut {
            productImageView.image = UIImage(named: selectedDonut.imageName)
        } else {
            productImageView.image = UIImage(named: "choose.png")      }
    }
    
    // Update the price label to show the total price for the selected quantity
    func updatePriceLabel() {
        if let selectedDonut = selectedDonut {
            let totalValue = selectedDonut.price * Double(selectedQuantity)
            priceTag.text = String(format: "$%.2f", totalValue)
        } else {
            priceTag.text = "$0.00"
        }
    }
    
    // Action triggered when the "Buy" button is pressed
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        // Ensure a donut is selected
        let selectedDonut = selectedDonut
        
        // Calculate the total value of the purchase
//        let totalValue = selectedDonut!.price * Double(selectedQuantity)
        let donutWord = selectedQuantity > 1 ? "donuts" : "donut"
        // Create a sale info string
        let saleInfo = "\(selectedQuantity) \(String(describing: selectedDonut!.shortName)) \(donutWord) added to your cart!"
        
        
        // Display a success alert with the sale info
        let alert = UIAlertController(title: "Success", message: saleInfo, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
