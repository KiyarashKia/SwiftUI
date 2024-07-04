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
    
    @IBOutlet weak var multiSwitch1: UISwitch!
    @IBOutlet weak var multiSwitch2: UISwitch!
    @IBOutlet weak var multiSwitch3: UISwitch!
    @IBOutlet weak var multiSwitch4: UISwitch!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var rangedSlider: UISlider!
    
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
        ]
        
        var questionIndex = 0
        var answersChosen: [Answer] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            updateUI()
        }
        
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        
        switch sender {
        case singleButton1:
            answersChosen.append(currentAnswers[0])
            
        case singleButton2:
            answersChosen.append(currentAnswers[1])
            
        case singleButton3:
            answersChosen.append(currentAnswers[2])
            
        case singleButton4:
            answersChosen.append(currentAnswers[3])
        default:
            break
        }
        nextQuestion()
    }
    
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        
        if multiSwitch1.isOn {
            answersChosen.append(currentAnswers[0])
        }
        if multiSwitch2.isOn {
            answersChosen.append(currentAnswers[1])
        }
        if multiSwitch3.isOn {
            answersChosen.append(currentAnswers[2])
        }
        if multiSwitch4.isOn {
            answersChosen.append(currentAnswers[3])
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        
        answersChosen.append(currentAnswers[index])
    
        nextQuestion()
    }
    
        func updateUI() {
            singleStackView.isHidden = true
            multipleStackView.isHidden = true
            rangedStackView.isHidden = true
            
            let currentQuestion = questions[questionIndex]
            let currentAnswers = currentQuestion.answers
            let totalProgress = Float(questionIndex) / Float(questions.count)
            
            navigationItem.title = "Question #\(questionIndex + 1)"
            questionLabel.text = currentQuestion.text
            questionProgressView.setProgress(totalProgress, animated: true)
            
            switch currentQuestion.type {
            case .single:
                updateSingleStack(using: currentAnswers)
            case .multiple:
                updateMultipleStack(using: currentAnswers)
            case .ranged:
                updateRangedStack(using: currentAnswers, for: currentQuestion.type)
            }
        }
        
        func updateSingleStack(using answers: [Answer]) {
            singleStackView.isHidden = false
            
            singleButton1.setTitle(answers[0].text, for: .normal)
            singleButton2.setTitle(answers[1].text, for: .normal)
            singleButton3.setTitle(answers[2].text, for: .normal)
            singleButton4.setTitle(answers[3].text, for: .normal)
        }
        
        func updateMultipleStack(using answers: [Answer]) {
            multipleStackView.isHidden = false
            
            multiLabel1.text = answers[0].text
            multiLabel2.text = answers[1].text
            multiLabel3.text = answers[2].text
            multiLabel4.text = answers[3].text
        }
        
        func updateRangedStack(using answers: [Answer], for type: ResponseType) {
            rangedStackView.isHidden = false
                label1.text = answers.first?.text
                label2.text = answers.last?.text
            }
       }
