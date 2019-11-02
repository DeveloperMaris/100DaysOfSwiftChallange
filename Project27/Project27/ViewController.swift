//
//  ViewController.swift
//  Project27
//
//  Created by Maris Lagzdins on 02/11/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0



    override func viewDidLoad() {
        super.viewDidLoad()

//        drawRectangle()
        drawEmoji()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1

        if currentDrawType > 7 {
            currentDrawType = 0
        }

        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawTwin()
        default:
            break
        }
    }

    func drawRectangle() {
        let rendered = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = rendered.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10) // centered on the boarder, in this situation, 5 points inside and 5 points outside of our figure

            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }

    func drawCircle() {
        let rendered = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = rendered.image { ctx in
//            let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502) // One way to fix the stroke boarders
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)

            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10) // centered on the boarder, in this situation, 5 points inside and 5 points outside of our figure

            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }

    func drawCheckerboard() {
        let rendered = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = rendered.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)

            for row in 0..<8 {
                for col in 0..<8 {
//                    if (row + col) % 2 == 0 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }

        imageView.image = image
    }

    func drawRotatedSquares() {
        let rendered = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = rendered.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256) // We need to move, so that we are drawing from the center of our canvas, not the top-left corner

            let rotation = 16
            let amount = Double.pi / Double(rotation)

            for _ in 0..<rotation {
                // Each rotation moves the further and further.
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        imageView.image = image
    }

    func drawLines() {
        let rendered = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = rendered.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)

            var first = true
            var length: CGFloat = 256

            for _ in 0..<256 {
                ctx.cgContext.rotate(by: .pi / 2) // Rotated by 90 degrees
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }

                length *= 0.99
            }

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        imageView.image = image
    }

    func drawImagesAndText() {
        let rendered = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = rendered.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]

            let string = "The best-laid schemes o'\nmice an' men gang aft agley"

            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)

            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }

        imageView.image = image
    }

    func drawEmoji() {
        let rendered = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = rendered.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)

            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)

            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)

            ctx.cgContext.translateBy(x: 256, y: 256)

            let leftEye = CGRect(x: -125, y: -100, width: 50, height: 50)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.strokePath()

            let rightEye = CGRect(x: 75, y: -100, width: 50, height: 50)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.strokePath()

            let path = UIBezierPath()
            path.move(to: CGPoint(x: -100, y: 100))
            path.addQuadCurve(to: CGPoint(x: 100, y: 100), controlPoint: CGPoint(x: 0, y: 150))
            ctx.cgContext.addPath(path.cgPath)
            ctx.cgContext.strokePath()
        }

        imageView.image = image
    }

    func drawTwin() {
        let rendered = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = rendered.image { ctx in
            let letterPadding = 10.0
            let letterWidth = 150.0
            let letterTopPosition = 206.0
            let letterBottomPosition = 306.0

            var padding = letterPadding

            // Draw T
            ctx.cgContext.move(to: CGPoint(x: 0, y: letterTopPosition))
            ctx.cgContext.addLine(to: CGPoint(x: letterWidth, y: letterTopPosition))
            ctx.cgContext.move(to: CGPoint(x: letterWidth / 2.0, y: letterTopPosition))
            ctx.cgContext.addLine(to: CGPoint(x: letterWidth / 2.0, y: letterBottomPosition))

            padding = letterWidth + letterPadding

            // Draw W
            ctx.cgContext.move(to: CGPoint(x: padding, y: letterTopPosition))
            ctx.cgContext.addLine(to: CGPoint(x: padding + letterWidth / 4, y: letterBottomPosition))
            ctx.cgContext.addLine(to: CGPoint(x: padding + (letterWidth / 4) * 2, y: letterTopPosition))
            ctx.cgContext.addLine(to: CGPoint(x: padding + (letterWidth / 4) * 3, y: letterBottomPosition))
            ctx.cgContext.addLine(to: CGPoint(x: padding + letterWidth, y: letterTopPosition))

            padding = padding + letterWidth + letterPadding

            // Draw I
            ctx.cgContext.move(to: CGPoint(x: padding + 5, y: letterTopPosition))
            ctx.cgContext.addLine(to: CGPoint(x: padding + 5, y: letterBottomPosition))

            padding = padding + 10 + letterPadding

            // Draw N
            ctx.cgContext.move(to: CGPoint(x: padding, y: letterBottomPosition))
            ctx.cgContext.addLine(to: CGPoint(x: padding, y: letterTopPosition))
            ctx.cgContext.addLine(to: CGPoint(x: padding + letterWidth, y: letterBottomPosition))
            ctx.cgContext.addLine(to: CGPoint(x: padding + letterWidth, y: letterTopPosition))

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        imageView.image = image
    }
}

