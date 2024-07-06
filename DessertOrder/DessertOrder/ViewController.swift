//
//  ViewController.swift
//  DessertOrder
//
//  Created by Kiarash Kiya on 2024-07-05.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // default image before choosing a product
    struct DefaultImage {
        static let imageName = "choose.png"
    }
    // MARK: - Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectedProductLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceTag: UILabel!
    @IBOutlet weak var managerButton: UIImageView!
    
     
    
    @IBAction func buyButton(_ sender: Any) {
           if let selectedDonut = selectedDonut {
//               let totalValue = selectedDonut.price * Double(selectedQuantity)
               let donutWord = selectedQuantity > 1 ? "donuts" : "donut"
               let saleInfo = "\(selectedQuantity) \(selectedDonut.shortName) \(donutWord) added to your cart!"
               
               let alert = UIAlertController(title: "Success", message: saleInfo, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
           }
       }
    // MARK: - Properties
       let store = Store()
       var purchases: [Purchase] = []
       var selectedDonut: Donut?
       var selectedQuantity: Int = 1
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           pickerView.delegate = self
           pickerView.dataSource = self
           
           updateSelectedProductLabel()
           updateProductImageView()
           updatePriceLabel()
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleManagerButtonTap))
           managerButton.isUserInteractionEnabled = true
           managerButton.addGestureRecognizer(tapGesture)
       }
    // MARK: - Actions
        @objc func handleManagerButtonTap() {
           self.performSegue(withIdentifier: "managerVC", sender: self)
       }
    // MARK: - Navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "managerVC" {
               let managerVC = segue.destination as! ManagerViewController
               managerVC.purchases = purchases
               managerVC.store = store
           }
       }
    // MARK: - UIPickerViewDataSource
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 2
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           if component == 0 {
               return store.donuts.count
           } else {
               return selectedDonut?.availabilityCount ?? 0
           }
       }
    // MARK: - UIPickerViewDelegate
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if component == 0 {
               return store.donuts[row].title
           } else {
               return "\(row + 1)"
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           if component == 0 {
               selectedDonut = store.donuts[row]
               pickerView.reloadComponent(1)
               updateSelectedProductLabel()
               updateProductImageView()
               updatePriceLabel()
           } else {
               selectedQuantity = row + 1
               updatePriceLabel()
           }
       }
    // MARK: - Update UI
       func updateSelectedProductLabel() {
           if let selectedDonut = selectedDonut {
               selectedProductLabel.text = "\(selectedDonut.title)"
           } else {
               selectedProductLabel.text = "Select a product"
           }
       }
       
       func updateProductImageView() {
           if let selectedDonut = selectedDonut {
               productImageView.image = UIImage(named: selectedDonut.imageName)
           } else {
               productImageView.image = UIImage(named: "choose.png")
           }
       }
       
       func updatePriceLabel() {
           if let selectedDonut = selectedDonut {
               let totalValue = selectedDonut.price * Double(selectedQuantity)
               priceTag.text = String(format: "$%.2f", totalValue)
           } else {
               priceTag.text = "$0.00"
           }
       }
       
       @IBAction func buyButtonPressed(_ sender: UIButton) {
           if let selectedDonut = selectedDonut {
               let donutWord = selectedQuantity > 1 ? "donuts" : "donut"
               let saleInfo = "\(selectedQuantity) \(selectedDonut.shortName) \(donutWord) added to your cart!"
               
               let alert = UIAlertController(title: "Success", message: saleInfo, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
           }
       }
   }
