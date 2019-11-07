//
//  ViewController.swift
//  Projects 25-27 Challange
//
//  Created by Maris Lagzdins on 07/11/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import CoreGraphics
import UIKit

class ViewController: UIViewController {
    enum TextPosition {
        case top, bottom
    }

    @IBOutlet private var imageView: UIImageView!
    var shareButton: UIBarButtonItem!

    var selectedImage: UIImage?
    var topText: String?
    var bottomText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isToolbarHidden = false

        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        shareButton.isEnabled = false

        navigationItem.rightBarButtonItem = shareButton

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Import picture", style: .plain, target: self, action: #selector(promptImageSelection)),
            UIBarButtonItem(title: "Set top text", style: .plain, target: self, action: #selector(askForTopText)),
            UIBarButtonItem(title: "Set bottom text", style: .plain, target: self, action: #selector(askForBottomText)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }

    @objc
    private func promptImageSelection() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc
    private func shareTapped() {
        guard let image = imageView.image else { return }
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.popoverPresentationController?.barButtonItem = shareButton
        present(activity, animated: true)
    }

    @objc
    private func askForTopText() {
        askForText(withTitle: "Enter text for the top.") { [weak self] text in
            self?.topText = text
            self?.createMeme()
        }
    }

    @objc
    private func askForBottomText() {
        askForText(withTitle: "Enter text for the bottom.") { [weak self] text in
            self?.bottomText = text
            self?.createMeme()
        }
    }

    private func askForText(withTitle title: String, completion: @escaping (String?) -> Void) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac] _ in
            guard let text = ac?.textFields?.first?.text else { return }
            completion(text)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    private func createMeme() {
        guard let image = self.selectedImage else { return }
        draw(textAtTop: topText, textAtBottom: bottomText, on: image)
    }

    private func draw(textAtTop topText: String?, textAtBottom bottomText: String?, on image: UIImage) {
        let size = imageView.bounds
        let renderer = UIGraphicsImageRenderer(bounds: size)
        let meme = renderer.image { ctx in
            image.draw(in: size)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping

            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black
            shadow.shadowBlurRadius = 5

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 45),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white,
//                .shadow: shadow
                .strokeColor: UIColor.black,
                .strokeWidth: -3
            ]

            let options: NSStringDrawingOptions = .usesLineFragmentOrigin

            if let text = topText {
                let attributedText = NSAttributedString(string: text, attributes: attributes)
                let rect = NSString(string: text).boundingRect(with: size.size, options: options, attributes: attributes, context: nil)
                attributedText.draw(with: CGRect(x: 0, y: 20, width: size.width, height: rect.height), options: options, context: nil)
            }

            if let text = bottomText {
                let attributedText = NSAttributedString(string: text, attributes: attributes)
                let rect = NSString(string: text).boundingRect(with: size.size, options: options, attributes: attributes, context: nil)
                attributedText.draw(with: CGRect(x: 0, y: size.height - rect.height - 20, width: size.width, height: rect.height), options: options, context: nil)
            }
        }

        imageView.image = meme
        shareButton.isEnabled = true
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        selectedImage = image
        createMeme()
    }
}
