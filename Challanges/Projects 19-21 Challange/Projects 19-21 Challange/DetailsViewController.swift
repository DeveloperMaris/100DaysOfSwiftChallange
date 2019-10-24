//
//  DetailsViewController.swift
//  Projects 19-21 Challange
//
//  Created by Maris Lagzdins on 24/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    enum State {
        case create
        case edit(note: Note)
    }

    static let identifier = "DetailsViewController"

    @IBOutlet private var textView: UITextView! {
        didSet {
            textView.alwaysBounceVertical = true
            textView.keyboardDismissMode = .onDrag
        }
    }

    var manager: NotesManager!
    var state: State!

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(manager != nil, "Manager is required!")
        assert(state != nil, "State is reqired!")

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeNote)),
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        ]
        navigationController?.isToolbarHidden = false

        subscriteToKeyboardNotirifactions()
        if case .edit(let note) = state {
            setupTextView(with: note)
        }
    }

    @objc
    func saveNote() {
        guard let text = textView.text else {
            return
        }

        let titleMaxLength = 10
        var title = String(text.prefix(titleMaxLength))

        if text.count > titleMaxLength {
            title = title.appending("...")
        }

        switch state {
        case .create:
            let note = Note(title: title, text: text)
            manager.add(note)
        case .edit(var note):
            note.update(title: title, text: text)
            manager.update(note)
        default:
            break
        }

        navigationController?.popViewController(animated: true)
    }

    @objc
    func removeNote() {
        guard case .edit(let note) = state else { return }
        manager.remove(note)
        navigationController?.popViewController(animated: true)
    }

    @objc
    func shareTapped() {
        guard let text = textView.text else { return }
        let ac = UIActivityViewController(activityItems: [text], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

// MARK: - Keyboard
private extension DetailsViewController {
    func subscriteToKeyboardNotirifactions(_ notificationCenter: NotificationCenter = NotificationCenter.default) {
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc
    func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}

// MARK: - TextField
private extension DetailsViewController {
    func setupTextView(with note: Note) {
        textView.text = note.text
    }
}
