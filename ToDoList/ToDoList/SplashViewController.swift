//
//  SplashViewController.swift
//  ToDoList
//
//  Created by Kiarash Kiya on 2024-07-27.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var labels: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.00).cgColor,
            UIColor(red: 0.678, green: 1.847, blue: 0.902, alpha: 1.00).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)

        
    

        labels.alpha = 0

                // Animate the gradient and label after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.animate(withDuration: 1.5) {
                        gradientLayer.opacity = 1
                        self.labels.alpha = 1
                    }
                }

                // Transition to the main menu after an additional delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.performSegue(withIdentifier: "showMainMenu", sender: self)
                }
            }
        }
