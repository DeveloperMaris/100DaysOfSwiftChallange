//
//  PhotoViewController.swift
//  Projects 10-12 Challange
//
//  Created by Maris Lagzdins on 18/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!

    var selectedPhoto: CapturedPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedPhoto?.caption

        if let image = selectedPhoto?.image {
            let imagePath = Utils.getDocumentsDirectory().appendingPathComponent(image)
            imageView.image = UIImage(contentsOfFile: imagePath.path)
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
}
