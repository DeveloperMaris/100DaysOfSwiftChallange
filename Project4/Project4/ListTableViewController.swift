//
//  ListTableViewController.swift
//  Project4
//
//  Created by Maris Lagzdins on 05/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    var websites = ["apple.com", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Websites"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? ViewController {
            vc.initialWebsite = websites[indexPath.row]
            vc.websites = websites
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
