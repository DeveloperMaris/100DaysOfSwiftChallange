//
//  DetailViewController.swift
//  Projects 1-3 Challange
//
//  Created by Maris Lagzdins on 04/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            title = imageToLoad.uppercased()
            imageView.image = UIImage(named: imageToLoad)
        }
    }

    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("Could not load image")
            return
        }
        guard let country = selectedImage else {
            print("Could not get image name")
            return
        }

        let ac = UIActivityViewController(activityItems: [image, country.uppercased()], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}
