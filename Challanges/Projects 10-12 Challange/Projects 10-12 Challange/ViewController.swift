//
//  ViewController.swift
//  Projects 10-12 Challange
//
//  Created by Maris Lagzdins on 18/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate {
    var photos = [CapturedPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takePhoto))

        photos = loadPhotos()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Caption", for: indexPath)
        cell.textLabel?.text = photos[indexPath.row].caption
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController else { return }

        vc.selectedPhoto = photos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func takePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func loadPhotos() -> [CapturedPhoto] {
        let defaults = UserDefaults.standard

        guard let photosData = defaults.object(forKey: "Photos") as? Data else {
            return []
        }

        let jsonDecoder = JSONDecoder()
        return (try? jsonDecoder.decode([CapturedPhoto].self, from: photosData)) ?? []
    }

    func save() {
        let jsonEncoder = JSONEncoder()

        guard let dataToSave = try? jsonEncoder.encode(photos) else {
            assertionFailure("Could not encode photos")
            return
        }

        let defaults = UserDefaults.standard
        defaults.set(dataToSave, forKey: "Photos")
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = Utils.getDocumentsDirectory().appendingPathComponent(imageName)

        let ac = UIAlertController(title: "Add caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) {
            [weak self, weak ac, weak picker] _ in
            guard let caption = ac?.textFields?.first?.text else { return }

            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imagePath)
            }

            let capturedPhoto = CapturedPhoto(caption: caption, image: imageName)

            self?.photos.append(capturedPhoto)
            self?.save()
            self?.tableView.reloadData()

            picker?.dismiss(animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel) {
            [weak picker] _ in
            picker?.dismiss(animated: true)
        })

        picker.present(ac, animated: true)
    }
}
