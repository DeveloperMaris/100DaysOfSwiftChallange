//
//  ViewController.swift
//  Project1
//
//  Created by Maris Lagzdins on 03/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendTapped))

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadImages()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? ImageCell else {
            fatalError("Could not dequeue ImageCell")
        }
        cell.name.text = pictures[indexPath.item]
        cell.layer.cornerRadius = 7
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.selectedPictureNumber = indexPath.item + 1
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func recommendTapped() {
        let recommendation = "I really recommend this application to you!"
        let vc = UIActivityViewController(activityItems: [recommendation], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    fileprivate func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load
                pictures.append(item)
            }
        }

        pictures.sort()

        print(pictures)

        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
