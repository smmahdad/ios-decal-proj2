//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var displayedWordLabel: UILabel!
    
    //Figure out how to make words work well in uilabel
    
    var currentPhraseShowing : String?
    
    let blockedOutCharacter : Character = "-"
    
    let spaceCharacter : Character = " "
    
    var listOfGuessedCharacters : [Character]!
    
    var finalCorrectWord : String?
    
    @IBOutlet weak var hangmanImageView: UIImageView!
    
    @IBOutlet weak var guessTextField: UITextField!
    
    @IBOutlet weak var checkGuessButton: UIButton!
    
    @IBOutlet weak var actualIncorrectGuesses: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    var isGameOver : Bool?
    
    var numberOfWrongGuesses : Int?
    let maxNumberOfMistakes = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNewGameAttributes()
        self.checkGuessButton.addTarget(self, action: "buttonTapped", forControlEvents: .TouchUpInside)
        self.newGameButton.addTarget(self, action: "setNewGameAttributes", forControlEvents: .TouchUpInside)
    }
    
    func setNewGameAttributes() {
        self.isGameOver = false
        self.actualIncorrectGuesses!.text = ""
        self.currentPhraseShowing = ""
        self.hangmanImageView.image = UIImage(named: "hangman1.gif")
        self.listOfGuessedCharacters = [Character]()
        self.currentPhraseShowing = ""
        self.numberOfWrongGuesses = 0
        self.guessTextField.text = ""
        
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()!
        //        phrase = "This is a random nonesense sentence"
        self.finalCorrectWord = phrase.uppercaseString
        
        print(phrase)
        
        for character in phrase.characters {
            if character == self.spaceCharacter {
                //                self.currentPhraseShowing?.append(self.spaceCharacter)
                self.currentPhraseShowing?.append(self.spaceCharacter)
            } else {
                self.currentPhraseShowing?.append(self.blockedOutCharacter)
            }
            
            //            self.currentPhraseShowing?.append(self.spaceCharacter)
        }
        
        self.displayedWordLabel.text = self.currentPhraseShowing

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonTapped() {
        let currentGuessText = self.guessTextField.text!.uppercaseString
        
        //Check if:
        //More than 1 character
        //Game over
        //0 characters
        //Not a character
        
        if self.isGameOver! {
            //Do popover alert
            let alert = UIAlertController(title: "Game Over", message: "The game is over. Press 'New Game' to start a new game", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if currentGuessText.characters.count > 1 || currentGuessText.characters.count == 0 {
            //Do popover alert
            let alert = UIAlertController(title: "Wrong Input", message: "Please only choose one character to select.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            self.guessTextField.text = ""
        } else {
            //check if character in word
            let characterGuess = currentGuessText[currentGuessText.startIndex]
            if (currentGuessText.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) == nil) {
                //Invalid character alert
                let alert = UIAlertController(title: "Letters Only", message: "Please only use the standard English letters.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            } else if listOfGuessedCharacters.contains(characterGuess) {
                //popover of already guessed letter
                let alert = UIAlertController(title: "Already Selected", message: "You have already selected letter " + String(characterGuess) + ".", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            }
            else if self.finalCorrectWord!.rangeOfString(currentGuessText) != nil {
                self.isCorrect(characterGuess)
            } else {
                self.isWrong(characterGuess)
            }
            self.guessTextField.text = ""
        }
    }
    
    func isCorrect(guessedCharacter : Character) {
        var tempString = ""
        var i = 0
        var unknownsLeft = 0
        for char in self.finalCorrectWord!.characters {
            if char == guessedCharacter {
                tempString.append(guessedCharacter)
            } else {
                tempString.append(self.currentPhraseShowing![currentPhraseShowing!.startIndex.advancedBy(i)])
                if self.currentPhraseShowing![currentPhraseShowing!.startIndex.advancedBy(i)] == self.blockedOutCharacter {
                    unknownsLeft += 1
                }
            }
            
            i = i + 1
            
        }
        self.currentPhraseShowing = tempString
        self.displayedWordLabel.text = self.currentPhraseShowing
        
        if unknownsLeft == 0 {
            isGameOver = true
            let alert = UIAlertController(title: "Winner!", message: "Congratulations! You won. Press 'New Game' to start a new game", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func isWrong(guessedCharacter : Character) {
        numberOfWrongGuesses! += 1
        listOfGuessedCharacters.append(guessedCharacter)
        hangmanImageView.image = UIImage(named: "hangman" + String(numberOfWrongGuesses! + 1) + ".gif")
        
        if actualIncorrectGuesses!.text?.characters.count > 0 {
            actualIncorrectGuesses.text = actualIncorrectGuesses.text! + ", "
        }
        
        actualIncorrectGuesses.text = actualIncorrectGuesses.text! + String(guessedCharacter)
        
        if numberOfWrongGuesses == maxNumberOfMistakes {
            isGameOver = true
            let alert = UIAlertController(title: "Game Over", message: "The game is over. Press 'New Game' to start a new game", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
