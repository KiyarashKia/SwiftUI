//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Kiarash Kiya on 2024-07-03.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
        @IBOutlet var singleButton1: UIButton!
        @IBOutlet var singleButton2: UIButton!
        @IBOutlet var singleButton3: UIButton!
        @IBOutlet var singleButton4: UIButton!
    
    
    @IBOutlet weak var multipleStackView: UIStackView!
        @IBOutlet var multiLabel1: UILabel!
        @IBOutlet var multiLabel2: UILabel!
        @IBOutlet var multiLabel3: UILabel!
        @IBOutlet var multiLabel4: UILabel!
    
    
    @IBOutlet weak var rangedStackView: UIStackView!
        @IBOutlet var rangedLabel1Left: UILabel!
        @IBOutlet var rangedLabel1Right: UILabel!
    
        @IBOutlet var rangedLabel2Left: UILabel!
        @IBOutlet var rangedLabel2Right: UILabel!
    
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    var questions: [Question] = [
    Question(
        text: "What type of environment do you prefer?",
        type: .single,
        
        answers: [
            Answer(text: "Steak", type: .lion),
            Answer(text: "Fish", type: .cat),
            Answer(text: "Carrots", type: .rabbit),
            Answer(text: "Corn", type: .turtle)
            
    ]
    ),
    
    
    Question(
        text: "Which activities do you enjoy?",
        type: .multiple,
        
        answers: [
            Answer(text: "Sleeping", type: .cat),
            Answer(text: "Eating", type: .lion),
            Answer(text: "Swimming", type: .turtle),
            Answer(text: "Cuddling", type: .rabbit)
            
    ]
    ),
    
    
    Question(
        text: "How much do you enjoy car rides?",
        type: .ranged,
        
        answers: [
            Answer(text: "I dislike them", type: .cat),
            Answer(text: "I love them", type: .lion),
            Answer(text: "I barely notice them", type: .turtle),
            Answer(text: "I get a little nervous", type: .rabbit)
            
    ]
    ),
    
    Question(
        text: "Which is your preference socially?",
        type: .ranged,
        
        answers: [
            Answer(text: "Small groups", type: .cat),
            Answer(text: "New people", type: .lion),
            Answer(text: "One-to-One communication", type: .turtle),
            Answer(text: "Energetic gatherings", type: .rabbit)
            
    ]
    ),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    var questionIndex = 0
    var answerChosen: [Answer] = []
    
    
    func updateUI() {
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        navigationItem.title = "Question #\(questionIndex + 1)"
        
        let currentQuestion = questions[questionIndex]
        
        switch currentQuestion.type {
        case .single:
            singleStackView.isHidden = false
            
        case .multiple:
            multipleStackView.isHidden = false
            
        case .ranged:
            rangedStackView.isHidden = false
        }
    }
    
}
