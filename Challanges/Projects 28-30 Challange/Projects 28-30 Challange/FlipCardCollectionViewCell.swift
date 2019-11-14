//
//  FlipCardCollectionViewCell.swift
//  Projects 28-30 Challange
//
//  Created by Maris Lagzdins on 14/11/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class FlipCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "FlipCard"

    @IBOutlet private var imageView: UIImageView!

    private var frontImage: UIImage!
    private var backImage: UIImage!

    var isShowingFront: Bool {
        return imageView.image == frontImage
    }

    func configure(withFrontImage frontImage: UIImage, backImage: UIImage) {
        imageView.image = backImage

        self.frontImage = frontImage
        self.backImage = backImage

        self.imageView.alpha = 1.0
        self.isUserInteractionEnabled = true
    }

    func flip(_ completion: (() -> Void)? = nil) {
        isUserInteractionEnabled = false
        imageView.image = isShowingFront ? backImage : frontImage
        UIView.transition(with: imageView, duration: 0.25, options: .transitionFlipFromLeft, animations: nil) { _ in
            completion?()
            self.isUserInteractionEnabled = true
        }
    }

    func hide() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) {
            self.imageView.alpha = 0.0
        }
    }
}
