//
//  ResultsViewController.swift
//  PersonalityQuiz
//
//  Created by Kiarash Kiya on 2024-07-03.
//

import UIKit

class ResultsViewController: UIViewController {
    
    // Outlets for the result labels
    @IBOutlet weak var resultAnswerLabel: UILabel!
    @IBOutlet weak var resultDefinitionLabel: UILabel!
    
    // Variable to hold the responses passed from the previous view controller
    var responses: [Answer]
    
    // Custom initializer to handle the responses passed from the previous view controller
    init?(coder: NSCoder, responses: [Answer]) {
        self.responses = responses
        super.init(coder: coder)
    }
    
    // Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the back button to prevent the user from going back
        navigationItem.hidesBackButton = true
        
        // Calculate the personality result based on the responses
        calculatePersonalityResult()
        
        // Do any additional setup after loading the view.
    }
    
    // Function to calculate the personality result based on the responses
    func calculatePersonalityResult() {
        // Calculate the frequency of each type of answer
        let frequencyOfAnswers = responses.reduce(into: [:]) { (counts, answer) in
            counts[answer.type, default: 0] += 1
        }
        
        // Sort the answers by their frequency in descending order
        let frequentAnswersSorted = frequencyOfAnswers.sorted(by: { (pair1, pair2) in
            return pair1.value > pair2.value
        })
        
        // Get the most common answer
        let mostCommonAnswer = frequentAnswersSorted.first!.key
        
        // Update the result labels with the most common answer and its definition
        resultAnswerLabel.text = "You are a \(mostCommonAnswer.rawValue)!"
        resultDefinitionLabel.text = mostCommonAnswer.definition
    }
}
