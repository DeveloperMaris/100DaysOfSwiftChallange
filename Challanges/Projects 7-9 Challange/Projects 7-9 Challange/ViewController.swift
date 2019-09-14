//
//  ViewController.swift
//  Projects 7-9 Challange
//
//  Created by Maris Lagzdins on 14/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!

    var wordList = [String]()
    var word: String!

    var usedLetters = Set<String>()

    let maxWrongAnswers = 7
    var wrongAnswers = 0 {
        didSet {
            scoreLabel.text = "Wrong answers: \(wrongAnswers)/\(maxWrongAnswers)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords(then: startGame)
    }

    @IBAction func guessALetterTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Enter a letter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Let's try", style: .default, handler: {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            guard text.count == 1 else {
                self?.showMessage("Enter only 1 letter!", withTitle: "No no no...")
                return
            }

            if let letter = text.first {
                self?.guess(letter)
            }
        }))
        present(ac, animated: true)
    }

    func loadWords(then completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
                if let wordsContent = try? String(contentsOf: fileURL) {
                    self?.wordList = wordsContent.components(separatedBy: "\n")
                    DispatchQueue.main.async {
                        completion()
                    }
                    return
                }
            }

            DispatchQueue.main.async {
                self?.showMessage("Could not load word list!", withTitle: "Error!")
            }
        }
    }

    func showMessage(_ message: String, withTitle title: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }

    func startGame() {
        guard let currentWord = wordList.randomElement()?.lowercased() else { return }

        word = currentWord
        wordLabel.text = ""
        wrongAnswers = 0

        for _ in 0..<word.count {
            wordLabel.text = wordLabel.text?.appending("?")
        }
    }

    func restartGame(action: UIAlertAction) {
        usedLetters.removeAll()
        startGame()
    }

    func guess(_ letter: Character) {
        checkLetter(letter)
        refreshUI()
        checkGameState()
    }

    func checkLetter(_ letter: Character) {
        let strLetter = letter.lowercased()
        usedLetters.insert(strLetter)

        if !word.contains(strLetter) {
            wrongAnswers += 1
        }
    }

    func refreshUI() {
        wordLabel.text = ""
        for letter in word {
            let strLetter = String(letter)

            if usedLetters.contains(strLetter) {
                wordLabel.text = wordLabel.text?.appending(strLetter.uppercased())
            } else {
                wordLabel.text = wordLabel.text?.appending("?")
            }
        }
    }

    func checkGameState() {
        var title: String?
        var message: String?
        var showAlert = false

        if wrongAnswers == maxWrongAnswers {
            title = "You lost the game!"
            message = "The word was \(word!.uppercased())"
            showAlert = true
        } else if let text = wordLabel.text {
            if !text.contains("?") {
                title = "Congratulations!"
                message = "You won the game!"
                showAlert = true
            }
        }

        if showAlert, let title = title, let message = message {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again!", style: .default, handler: restartGame))
            present(ac, animated: true)
        }
    }
}
