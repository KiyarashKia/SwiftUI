//Name:Kiarash Kia
//Date: 4 June, 2024


import Foundation

// enum to hold the fixed values of possible game state cases which can be start of the game, and each win, lose or draw. these three are also considered the end of the game as well
enum GameState {
    case start // Case of Start
    case win   // Case of Winning side
    case lose  // Case of Losing side
    case draw  // Case of Draw
    
    var status: String {    // Defining each case's message as return to user per state
        switch self {
        case .start:
            return "Rock, Paper, Scissors, Lizard or Spock?"
        case .win:
            return "You Won!"
        case .lose:
            return "You Lost!"
        case .draw:
            return "It's a Draw!"
        }
    }
}
