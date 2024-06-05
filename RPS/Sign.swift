//Name:Kiarash Kia
//Date: May 27, 2024


import Foundation

// This function returns a Sign (one from the enum declared in this file)
func randomSign() -> Sign {
    let sign = Int.random(in: 0...4)    // a variable of a random int value in the range between 0 - 4, each representing a case
    if sign == 0 {        // if the sign is 0
        return .rock      // return Rock
    } else if sign == 1 { // if the sign is 1
        return .paper     // return Paper
    } else if sign == 2 { // if the sign is 2
        return .scissors  // return Scissors
    } else if sign == 3 { // if the sign is 3
        return .lizard    // return lizard
    } else {              // else means basically non of those, which means 4
        return .spock     // return spock, the last remaining sign
    }
}

// Defining the enum for gathering and holding all the possible signs in the game
enum Sign {
    case rock             // case rock
    case paper            // case rock
    case scissors         // case rock
    case lizard           // case rock
    case spock            // case rock
    
    var emoji: String {   // Declaring a constant string variable named emoji to specify an emoji for each case
        switch self {     // Examines and checks the current value of the enum instance, to further perform an action based on that value
        case .rock:       // In case of Rock
            return "👊"   // Return its sign
        case .paper:      // In case of Paper
            return "✋"   // Return its sign
        case .scissors:   // In case of Scissors
            return "✌️"   // Return its sign
        case .lizard:     // In case of Lizard
            return "🤏"   // Return its sign
        case .spock:      // In case of Spock
            return "🖖"   // Return its sign
        }
    }
    
    // Function gameState is responsible for getting the opponentSign choice and updating the GameState based on the result
    func gameState(against opponentSign: Sign) -> GameState {
        if self == opponentSign {   // If the function is called on a side and the sign of that side equals to the other side, it's a draw!
            return .draw    // Returning the state
        }
        
        switch self {   // Defining states and applying rules for each case and possibilities
        case .rock:
            if opponentSign == .scissors || opponentSign == .lizard {
                return .win
            }
        case .paper:
            if opponentSign == .rock || opponentSign == .spock {
                return .win
            }
        case .scissors:
            if opponentSign == .paper || opponentSign == .lizard {
                return .win
            }
        case .lizard:
            if opponentSign == .paper || opponentSign == .spock {
                return .win
            }
        case .spock:
            if opponentSign == .scissors || opponentSign == .rock {
                return .win
            }
        }
        return .lose
    }
}
