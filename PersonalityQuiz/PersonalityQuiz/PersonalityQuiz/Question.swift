//
//  Question.swift
//  PersonalityQuiz
//
//  Created by Kiarash Kiya on 2024-07-03.
//

import Foundation


struct Question {
    var text: String
    var type: ResponseType
    var answers: [Answer]
}

enum ResponseType {
    case single, multiple, ranged
}
