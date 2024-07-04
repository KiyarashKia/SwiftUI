//
//  Answers.swift
//  PersonalityQuiz
//
//  Created by Kiarash Kiya on 2024-07-03.
//

import Foundation

// This struct represents an answer choice in the quiz.
struct Answer {
    var text: String // The text of the answer choice
    var type: AnimalType // The animal type associated with the answer
}

// This enum represents different animal types and includes an emoji for each type.
enum AnimalType: Character {
    case lion = "🦁" // Lion emoji
    case cat = "🐱" // Cat emoji
    case rabbit = "🐰" // Rabbit emoji
    case turtle = "🐢" // Turtle emoji
    
    // This computed property provides a description for each animal type.
    var definition: String {
        switch self {
        case .lion:
            return "You are a brave and adventurous person who loves the great outdoors and open fields. You seek out new experiences and enjoy exploring new places. Networking and meeting new people excite you, and you approach challenges with confidence and determination, ready to tackle them head-on."
            
        case .cat:
            return "You are an independent person who thrives in cozy, quiet environments. Your ideal day involves lounging and relaxing, enjoying moments of solitude or the company of a small, close-knit group of friends. You appreciate a tranquil and comfortable setting, where you can unwind and feel at ease."
            
        case .rabbit:
            return "You are an energetic and lively person who thrives in active environments. You enjoy running, jumping, and engaging in various sports. Socializing at large gatherings and being surrounded by people invigorates you. You love the hustle and bustle of lively settings, where you can express your energy and enthusiasm."
            
        case .turtle:
            return "You are a patient and reflective person who values calm and peaceful environments. You enjoy meditating, reading, and engaging in quiet, introspective activities. One-on-one conversations are your preference, as they allow for deep and meaningful connections. You appreciate a slow-paced life that offers time for thought and contemplation."
        }
    }
}

