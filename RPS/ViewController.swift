//Name: Kiarash Kia
//Date: 4 June, 2024


import UIKit

// VewController   class   to manage game's UI
class ViewController: UIViewController {

    // Set of Outlets for the UI elements in the storyboard
    @IBOutlet weak var signLabel: UILabel!      // Label for computer sign
    @IBOutlet weak var statusLabel: UILabel!    // Label for game result
    
    @IBOutlet weak var rockButton: UIButton!    // Rock button
    @IBOutlet weak var paperButton: UIButton!   // Paper button
    @IBOutlet weak var scissorsButton: UIButton!    // Scissors button
    @IBOutlet weak var lizardButton: UIButton!      // Lizard button
    @IBOutlet weak var spockButton: UIButton!       // Spock Button
    
    @IBOutlet weak var playAgainButton: UIButton!   // Play again button
        
    @IBOutlet weak var winCounter: UILabel!  // Label for Win Count
    @IBOutlet weak var drawCounter: UILabel! // Label for Draw Count
    @IBOutlet weak var lossCounter: UILabel! // Label for Loss Count
    
    
    var winCount = 0
    var drawCount = 0
    var lossCount = 0
    
    //  A method to be called   to ensure the view has been loaded successfuly
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI(forState: .start)      // Initialize he UI to the start state
        updateCounters()
    }

    // Action method for when each sign button is pressed by user
    @IBAction func rockChosen(_ sender: Any) {
        play(userSign: .rock)   // Rock
    }
    
    @IBAction func paperChosen(_ sender: Any) {
        play(userSign: .paper)  // Paper
    }
    
    @IBAction func scissorsChosen(_ sender: Any) {
        play(userSign: .scissors)   // Scissors
    }
    
    @IBAction func lizardChosen(_ sender: Any) {
        play(userSign: .lizard)      // Lizard
    }
    
    @IBAction func spockChosen(_ sender: Any) {
        play(userSign: .spock)  // Spock
    }
    
    @IBAction func playAgain(_ sender: Any) {
        updateUI(forState: .start)  // Resets th UI to start state
    }
    
    
    
    //  Updates te UI based on the current state
    func updateUI(forState state: GameState) {
        statusLabel.text = state.status // Updates the game status label
        updateCounters()
        // Switch cast to set the state accordingly
        switch state {
        case .start:
            view.backgroundColor = .gray // Setting the BG color to gray
            
            signLabel.text = "🤖"   // Computer sign
            playAgainButton.isHidden = true // Hiding the play again button in the start state
                
            // Keep showing all the buttons necessary in the beginning stage of the game
            rockButton.isHidden = false
            paperButton.isHidden = false
            scissorsButton.isHidden = false
            lizardButton.isHidden = false
            spockButton.isHidden = false

            // Keeping all necessary buttons functional and interactive
            rockButton.isEnabled = true
            paperButton.isEnabled = true
            scissorsButton.isEnabled = true
            lizardButton.isEnabled = true
            spockButton.isEnabled = true
            
            // Result cases
        case .win:
            view.backgroundColor = UIColor(red: 0.651, green: 0.792, blue: 0.651, alpha: 1) // Changes the view's BG color accordingly
        case .lose:
            view.backgroundColor = UIColor(red: 0.851, green: 0.424, blue: 0.412, alpha: 1) // Changes the view's BG color accordingly
        case .draw:
            view.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1) // Changes the view's BG color accordingly
        }
    }
    
    // Game's logic handler function when a sign is chosen by the user
    func play(userSign: Sign) {
        let computerSign = randomSign() // Computer chooses a random sign
        
        let gameState = userSign.gameState(against: computerSign)
        updateUI(forState: gameState) // Detemining the result by   referring to the gameState logical function that compares players signs and returns the game state
        
        signLabel.text = computerSign.emoji // Shows the emoji of computer's choice
        
        switch gameState {
        case .win:
            winCount += 1
        case .draw:
            drawCount += 1
        case .lose:
            lossCount += 1
        default:
            break
        }
        // Setting the   buttons and functionality of them hidden and deactivated
        rockButton.isHidden = true
        paperButton.isHidden = true
        scissorsButton.isHidden = true
        lizardButton.isHidden = true
        spockButton.isHidden = true

        rockButton.isEnabled = false
        paperButton.isEnabled = false
        scissorsButton.isEnabled = false
        lizardButton.isEnabled = false
        spockButton.isEnabled = false
        
        // Showing only the user's chosen sign
        switch userSign {
        case .rock:
            rockButton.isHidden = false
        case .paper:
            paperButton.isHidden = false
        case .scissors:
            scissorsButton.isHidden = false
        case .lizard:
            lizardButton.isHidden = false
        case .spock:
            spockButton.isHidden = false
        }
        playAgainButton.isHidden = false    // Showing the play again button
    }
    
    func updateCounters() {
        winCounter.text = "\(winCount)"
        drawCounter.text = "\(drawCount)"
        lossCounter.text = "\(lossCount)"
    }
}

