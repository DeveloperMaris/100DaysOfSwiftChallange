//
//  ActionViewController.swift
//  Extension
//
//  Created by Maris Lagzdins on 21/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol ActionViewControllerDelegate: AnyObject {
    func load(script: Script)
}

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!

    private let queue = DispatchQueue(label: "com.developermaris.Project19.Extension.userDefaults.savedCode", qos: .utility)
    private var scriptManager: ScriptManager!

    var pageTitle: String = ""
    var pageURL: String = ""


    var scripts: [String] = [
        "alert(document.title);",
        "alert(document.URL);"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        scriptManager = ScriptManager()

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertScript))
        ]

        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSavedScripts)),
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveScript))
        ]

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else {
                        return
                    }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {
                        return
                    }

                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""

                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.script.text = self?.loadCode()
                    }
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])

        saveCode()
    }

    @objc
    private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

    @objc
    private func insertScript() {
        let ac = UIAlertController(title: "Scripts", message: nil, preferredStyle: .actionSheet)
        for script in scripts {
            ac.addAction(UIAlertAction(title: script, style: .default) { [weak self] _ in
                self?.script.text = self?.script.text.appending(script)
            })
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    private func loadCode() -> String {
        queue.sync { [weak self] in
            guard let self = self else { return "" }
            guard let url = URL(string: self.pageURL), let host = url.host else { return "" }

            let usersDefault = UserDefaults.standard
            return usersDefault.object(forKey: host) as? String ?? ""
        }
    }

    private func saveCode() {
        guard let script = self.script.text, script.count > 0 else { return }

        queue.async { [weak self] in
            guard let self = self else { return }
            guard let url = URL(string: self.pageURL), let host = url.host else { return }

            let usersDefault = UserDefaults.standard
            usersDefault.set(script, forKey: host)
        }
    }

    @objc
    private func saveScript() {
        guard let script = self.script.text, script.count > 0 else { return }

        let ac = UIAlertController(title: "Provide script title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let self = self else { return }
            guard let title = ac?.textFields?[0].text else { return }
            self.scriptManager.saveScript(self.script.text, withTitle: title)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    @objc
    private func showSavedScripts() {
        guard let vc = storyboard?.instantiateViewController(identifier: "ScriptsTableViewController") as? ScriptsTableViewController else {
            fatalError("Could not load ScriptsTableViewController")
        }

        vc.delegate = self
        vc.scripts = scriptManager.loadScripts()

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ActionViewController: ActionViewControllerDelegate {
    func load(script: Script) {
        self.script.text = script.code
    }
}
