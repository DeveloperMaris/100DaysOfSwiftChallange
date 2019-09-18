//
//  ViewController.swift
//  Project2
//
//  Created by Maris Lagzdins on 03/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var askedQuestions = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scoreTapped))

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        navigationItem.prompt = "Your score is \(score)"

        guard askedQuestions < 10 else {
            let title: String
            let message: String

            if score > highscore() {
                save(score)
                title = "Congratulations"
                message = "Your new Highscore and final score is \(score)"
            } else {
                title = "Congratulations"
                message = "Your final score is \(score)"
            }

            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart game", style: .default, handler: restart))
            present(ac, animated: true)
            return
        }

        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        title = countries[correctAnswer].uppercased()

        askedQuestions += 1
    }

    func restart(action: UIAlertAction! = nil) {
        score = 0
        askedQuestions = 0

        askQuestion()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var isAnswerCorrect: Bool
        if sender.tag == correctAnswer {
            isAnswerCorrect = true
            score += 1
        } else {
            isAnswerCorrect = false
            score -= 1
        }

        if !isAnswerCorrect {
            let ac = UIAlertController(title: "Wrong", message: "That's the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))

            present(ac, animated: true)
        } else {
            askQuestion()
        }
    }

    @objc func scoreTapped() {
        let ac = UIAlertController(title: nil, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        present(ac, animated: true)
    }

    func save(_ score: Int) {
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: "Highscore")
    }

    func highscore() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: "Highscore")
    }
}
