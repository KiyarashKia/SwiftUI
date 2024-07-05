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
    case lion = "🦁", cat = "🐱", rabbit = "🐰", turtle = "🐢"
    
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
    
    
    // Adding tips for the new feature to show if user is interested in
    var tips: String {
        switch self {
        case .lion:
            return """
            - Set realistic goals to avoid burnout from taking on too much.
            - Practice mindfulness to stay grounded and focused.
            - Balance your adventurous spirit with time for rest and relaxation.
            """
        case .cat:
            return """
            - Create a daily routine to help manage your time effectively.
            - Set aside time for social interactions to avoid feeling isolated.
            - Engage in hobbies that stimulate your mind and creativity.
            """
        case .rabbit:
            return """
            - Ensure you get enough rest to recharge your energy.
            - Try new activities to keep your life exciting and fulfilling.
            - Practice deep breathing or meditation to manage stress and stay calm.
            """
        case .turtle:
            return """
            - Set small, achievable goals to stay motivated.
            - Balance your quiet time with social activities to stay connected.
            - Engage in physical activities to maintain your health and well-being.
            """
        }
    }
}

