//
//  ViewController.swift
//  Project1
//
//  Created by Maris Lagzdins on 03/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var pictureViewCount = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendTapped))

        loadImages()

        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "PictureViewCount") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                pictureViewCount = try jsonDecoder.decode([String: Int].self, from: savedData)
            } catch {
                print("Could not parse saved data")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Views: \(pictureViewCount[pictures[indexPath.row], default: 0])"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pictureViewCount[pictures[indexPath.row], default: 0] += 1
        save()

        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)

            for item in items {
                if item.hasPrefix("nssl") {
                    // this is a picture to load
                    self?.pictures.append(item)
                }
            }

            self?.pictures.sort()

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func save() {
        let jsonEncoder = JSONEncoder()

        if let dataToSave = try? jsonEncoder.encode(pictureViewCount) {
            let defaults = UserDefaults.standard

            defaults.set(dataToSave, forKey: "PictureViewCount")
        } else {
            print("Failed to save picture view count")
        }
    }
}
