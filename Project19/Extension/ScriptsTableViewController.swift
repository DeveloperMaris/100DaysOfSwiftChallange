//
//  ScriptsTableViewController.swift
//  Extension
//
//  Created by Maris Lagzdins on 21/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ScriptsTableViewController: UITableViewController {
    static let cellIdentifier = "script"

    var scripts: [Script] = []
    weak var delegate: ActionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)

        cell.textLabel?.text = scripts[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let script = scripts[indexPath.row]
        delegate?.load(script: script)

        navigationController?.popViewController(animated: true)
    }
}
