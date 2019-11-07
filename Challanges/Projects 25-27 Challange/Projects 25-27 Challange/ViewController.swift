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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        shareButton.isEnabled = false
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptImageSelection)),
            shareButton
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

    private func askForText(at position: TextPosition, completion: @escaping (String?) -> Void) {
        let title: String

        switch position {
        case .top:
            title = "Enter text for the top."
        case .bottom:
            title = "Enter text for the bottom."
        }

        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac] _ in
            guard let text = ac?.textFields?.first?.text else { return }
            completion(text)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        })
        present(ac, animated: true)
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
                .shadow: shadow
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
        imageView.image = image

        askForText(at: .top) { [weak self] topText in
            self?.askForText(at: .bottom) { bottomText in
                guard topText != nil || bottomText != nil else { return }
                self?.draw(textAtTop: topText, textAtBottom: bottomText, on: image)
            }
        }
    }
}
