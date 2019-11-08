//
//  ViewController.swift
//  Project28
//
//  Created by Maris Lagzdins on 08/11/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!

    var lockButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Nothing to see here"

        lockButton = UIBarButtonItem(title: "Lock", style: .plain, target: self, action: #selector(saveSecretMessage))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)

        setupPasswordIfNeeded()
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError? // Objc. form of Swift Error type

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!" // Only for Touch ID, for Face ID - there is a key inside info.plist

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // error
//                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "OK", style: .default))
//                        self?.present(ac, animated: true)

                        self?.askForPasswordAuthentication()
                    }
                }
            }
        } else {
            // no biometry
//            let ac = UIAlertController(title: "Bimetry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)

            askForPasswordAuthentication()
        }
    }

    @objc
    private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

    private func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"

        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""

        navigationItem.rightBarButtonItem = lockButton
    }

    @objc
    private func saveSecretMessage() {
        guard secret.isHidden == false else { return }

        navigationItem.rightBarButtonItem = nil

        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true

        title = "Nothing to see here"
    }

    private func setupPasswordIfNeeded() {
        guard KeychainWrapper.standard.string(forKey: "Password") == nil else { return }

        let ac = UIAlertController(title: "Provide password for the app authentication fallback!", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?.first?.text else { return }
            self?.savePassword(text)
        })
        present(ac, animated: true)
    }

    private func savePassword(_ password: String) {
        if password.isEmpty {
            let ac = UIAlertController(title: "Password cannot be empty!", message: "Please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.setupPasswordIfNeeded()
            })
            present(ac, animated: true)
        } else {
            KeychainWrapper.standard.set(password, forKey: "Password")
        }
    }

    private func isPasswordCorrect(_ password: String) -> Bool {
        guard let savedPassword = KeychainWrapper.standard.string(forKey: "Password") else {
            return false
        }

        return savedPassword == password
    }

    private func askForPasswordAuthentication() {
        let ac = UIAlertController(title: "Enter password!", message: nil, preferredStyle: .alert)
        ac.addTextField { textfield in
            textfield.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "Login", style: .default) { [weak self, weak ac] _ in
            guard let self = self else { return }
            guard let text = ac?.textFields?.first?.text else { return }
            if self.isPasswordCorrect(text) {
                self.unlockSecretMessage()
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

