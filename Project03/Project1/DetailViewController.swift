//
//  DetailViewController.swift
//  Project1
//
//  Created by Maris Lagzdins on 03/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Picture \(selectedPictureNumber) of \(totalPictures)"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped() {
        guard let image = imageView.image else {
            print("No image found")
            return
        }

        guard let imageName = selectedImage else {
            print("No image name found")
            return
        }

        guard let sharableImage = createImageWithText(from: image).jpegData(compressionQuality: 0.8) else {
            print("Could not generate an image data")
            return
        }

        let vc = UIActivityViewController(activityItems: [sharableImage, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    private func createImageWithText(from image: UIImage) -> UIImage {
        let rendered = UIGraphicsImageRenderer(size: image.size)

        return rendered.image { ctx in
            image.draw(at: .zero)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle
            ]

            let string = "From Storm Viewer"

            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 20, y: 20, width: image.size.width - 40, height: image.size.height >= 240 ? 200 : image.size.height - 20), options: .usesLineFragmentOrigin, context: nil)
        }
    }
}
