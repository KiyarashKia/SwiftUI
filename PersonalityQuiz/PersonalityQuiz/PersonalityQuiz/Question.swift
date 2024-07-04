//
//  Question.swift
//  PersonalityQuiz
//
//  Created by Kiarash Kiya on 2024-07-03.
//

import Foundation


// This struct represents a question in the personality quiz
struct Question {
    var text: String       // The text of the question
    var type: ResponseType // The type of response expected for the question
    var answers: [Answer]  // The possible answers for the question
}

// This enum represents the different types of responses a question can have
enum ResponseType {
    case single   // Single answer question type
    case multiple // Multiple answer question type
    case ranged   // Ranged answer question type
}
