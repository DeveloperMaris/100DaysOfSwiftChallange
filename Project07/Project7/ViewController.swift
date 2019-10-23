//
//  ViewController.swift
//  Project7
//
//  Created by Maris Lagzdins on 11/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var searchText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
//            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        let infoButton = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(inform))
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter))
        let clearFilterButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearFilter))
        navigationItem.rightBarButtonItems = [infoButton, clearFilterButton, filterButton]

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        showError()
    }

    @objc func inform() {
        let ac = UIAlertController(title: "Data source", message: "White House API", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc func filter() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Go", style: .default, handler: {
            [weak self, weak ac] _ in
            guard let searchText = ac?.textFields?[0].text else { return }
            guard let self = self else { return }

            DispatchQueue.global(qos: .userInitiated).async {
                self.searchText = searchText
                self.filteredPetitions = self.petitions.filter { $0.body.contains(searchText) || $0.title.contains(searchText) }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }))
        present(ac, animated: true)
    }

    @objc func clearFilter() {
        searchText = nil
        filteredPetitions = petitions
        tableView.reloadData()
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        vc.searchText = searchText
        navigationController?.pushViewController(vc, animated: true)
    }
}
