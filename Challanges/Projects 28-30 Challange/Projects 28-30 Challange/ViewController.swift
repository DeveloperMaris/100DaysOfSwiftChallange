//
//  ViewController.swift
//  Projects 28-30 Challange
//
//  Created by Maris Lagzdins on 11/11/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import CoreGraphics
import UIKit

class ViewController: UICollectionViewController {
    enum GameState {
        case zeroCardsSelected
        case oneCardSelected
        case twoCardsSelected
    }

    var gameState: GameState = .zeroCardsSelected

    var items = [PairItem]()
    var foundedPairCount = 0

    var isGameOver: Bool {
        return foundedPairCount == items.count / 2
    }

    var backImageCache = [Int: UIImage]()
    var frontImageCache = [Int: UIImage]()

    var firstSelectedCardIndex: IndexPath?
    var secondSelectedCardIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Memory trainer"
        setup()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlipCardCollectionViewCell.identifier, for: indexPath) as? FlipCardCollectionViewCell else { fatalError("Could not load FlipCardCollectionViewCell") }

        cell.configure(withFrontImage: frontImageCache[indexPath.item]!, backImage: backImageCache[indexPath.item]!)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard firstSelectedCardIndex != indexPath else { return }
        guard secondSelectedCardIndex != indexPath else { return }
        guard gameState == .zeroCardsSelected || gameState == .oneCardSelected else { return }

        guard (firstSelectedCardIndex == nil && secondSelectedCardIndex == nil) || (firstSelectedCardIndex != nil && secondSelectedCardIndex == nil) else { return }

        let currentState: GameState // We need to use copy of current game state to not create race conditions inside the flip completion handler

        if self.firstSelectedCardIndex == nil {
            currentState = .oneCardSelected
            self.firstSelectedCardIndex = indexPath
        } else if self.secondSelectedCardIndex == nil {
            currentState = .twoCardsSelected
            self.secondSelectedCardIndex = indexPath
        } else {
            return
        }

        gameState = currentState

        guard let currentCell = collectionView.cellForItem(at: indexPath) as? FlipCardCollectionViewCell else { return }

        currentCell.flip {
            if currentState == .twoCardsSelected {
                let previousCell = collectionView.cellForItem(at: self.firstSelectedCardIndex!) as? FlipCardCollectionViewCell

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.selectedItemsMakesPair() {
                        self.foundedPairCount += 1

                        currentCell.hide()
                        previousCell?.hide()

                        if self.isGameOver {
                            let ac = UIAlertController(title: "You WIN", message: nil, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: self.restart))
                            self.present(ac, animated: true)
                        }
                    } else {
                        currentCell.flip()
                        previousCell?.flip()
                    }

                    self.firstSelectedCardIndex = nil
                    self.secondSelectedCardIndex = nil

                    self.gameState = .zeroCardsSelected
                }
            }
        }
    }

    func selectedItemsMakesPair() -> Bool {
        guard let firstItemIndex = firstSelectedCardIndex?.item else { return false }
        guard let secondItemIndex = secondSelectedCardIndex?.item else { return false }

        return items[firstItemIndex].pairIdentifier == items[secondItemIndex].pairIdentifier
    }
}

private extension ViewController {
    func setup() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            var items = self.loadPairs()
            items.shuffle()

            let cardSize = CGSize(width: 200, height: 150)

            for (index, item) in items.enumerated() {
                let backImage = self.generateBackImage(withSize: cardSize)
                let frontImage = self.generateFrontImage(with: item.value, size: cardSize)

                self.backImageCache[index] = backImage
                self.frontImageCache[index] = frontImage
            }

            self.items = items

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    @objc
    func restart(action: UIAlertAction) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.foundedPairCount = 0
            self.backImageCache.removeAll(keepingCapacity: true)
            self.frontImageCache.removeAll(keepingCapacity: true)

            var items = self.items
            items.shuffle()

            let cardSize = CGSize(width: 200, height: 150)

            for (index, item) in items.enumerated() {
                let backImage = self.generateBackImage(withSize: cardSize)
                let frontImage = self.generateFrontImage(with: item.value, size: cardSize)

                self.backImageCache[index] = backImage
                self.frontImageCache[index] = frontImage
            }

            self.items = items

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    func changeState() {
        switch gameState {
        case .zeroCardsSelected:
            gameState = .oneCardSelected
        case .oneCardSelected:
            gameState = .twoCardsSelected
        case .twoCardsSelected:
            gameState = .zeroCardsSelected
        }
    }

    func loadPairs() -> [PairItem] {
        guard let path = Bundle.main.url(forResource: "Pairs", withExtension: "txt") else {
            fatalError("Can't find the Pairs file")
        }

        guard let content = try? String(contentsOf: path) else {
            fatalError("Can't load the content from Pairs file")
        }

        var items = [PairItem]()

        let lines = content.components(separatedBy: "\n")

        for line in lines {
            let pair = line.components(separatedBy: "|")
            print("Pairs are \(pair)")

            let identifier = UUID()
            items.append(PairItem(pairIdentifier: identifier, value: pair[0]))
            items.append(PairItem(pairIdentifier: identifier, value: pair[1]))
        }

        return items
    }

    func generateFrontImage(with text: String, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let rectangle = CGRect(origin: .zero, size: size).insetBy(dx: 1, dy: 1)

            // Background
            ctx.cgContext.setLineWidth(2.0)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)

            let path = UIBezierPath(roundedRect: rectangle, cornerRadius: 30).cgPath
            ctx.cgContext.addPath(path)
            ctx.cgContext.drawPath(using: .stroke)

            // Image text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 30),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black
            ]

            let attributedString = NSAttributedString(string: text, attributes: attributes)
            let options = NSStringDrawingOptions.usesLineFragmentOrigin
            let textSize = NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)

            attributedString.draw(with: CGRect(x: size.width / 2 - textSize.width / 2, y: size.height / 2 - textSize.height / 2, width: textSize.width, height: textSize.height), options: options, context: nil)
        }

        return image
    }

    func generateBackImage(withSize size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let rectangle = CGRect(origin: .zero, size: size).insetBy(dx: 1, dy: 1)

            // Image background
            let hue = CGFloat.random(in: 0.000...1.000)
            UIColor(hue: hue, saturation: 0.99, brightness: 0.67, alpha: 1).setFill()

            ctx.cgContext.setLineWidth(2.0)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)

            let path = UIBezierPath(roundedRect: rectangle, cornerRadius: 30).cgPath
            ctx.cgContext.addPath(path)
            ctx.cgContext.drawPath(using: .fillStroke)

            ctx.cgContext.addEllipse(in: CGRect(x: size.width / 2 - 25, y: size.height / 2 - 25, width: 50, height: 50))
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.fillPath()

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 30),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black
            ]

            let symbol = "?"
            let attributedString = NSAttributedString(string: symbol, attributes: attributes)
            let options = NSStringDrawingOptions.usesLineFragmentOrigin
            let textSize = NSString(string: symbol).boundingRect(with: size, options: options, attributes: attributes, context: nil)

            attributedString.draw(with: CGRect(x: size.width / 2 - textSize.width / 2, y: size.height / 2 - textSize.height / 2, width: textSize.width, height: textSize.height), options: options, context: nil)
        }

        return image
    }
}
