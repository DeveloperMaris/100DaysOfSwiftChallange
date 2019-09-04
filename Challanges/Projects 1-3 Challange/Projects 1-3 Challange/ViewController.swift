//
//  ViewController.swift
//  Projects 1-3 Challange
//
//  Created by Maris Lagzdins on 04/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country flags"
        navigationController?.navigationBar.prefersLargeTitles = true

        let fm = FileManager()
        let path = Bundle.main.resourcePath!

        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items where item.hasSuffix(".png") {
            let country = String(item[..<item.firstIndex(of: ".")!])
            countries.append(country)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.textLabel?.text = countries[indexPath.row].uppercased()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.selectedImage = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
