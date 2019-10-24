//
//  ViewController.swift
//  Projects 19-21 Challange
//
//  Created by Maris Lagzdins on 24/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes: [Note] = []
    var manager: NotesManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
        ]
        navigationController?.isToolbarHidden = false

        manager = NotesManager(database: UserDefaultsDatabase())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        notes = manager.loadNotes()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)

        cell.textLabel?.text = notes[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: DetailsViewController.identifier) as? DetailsViewController else {
            fatalError("Could not load DetailsViewController")
        }
        let note = notes[indexPath.row]
        vc.state = .edit(note: note)
        vc.manager = manager
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func createNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: DetailsViewController.identifier) as? DetailsViewController else {
            fatalError("Could not load DetailsViewController")
        }
        vc.state = .create
        vc.manager = manager
        navigationController?.pushViewController(vc, animated: true)
    }
}
