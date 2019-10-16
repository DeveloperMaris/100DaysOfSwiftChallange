//
//  CountryListTableViewController.swift
//  Projects 11-13 Challange
//
//  Created by Maris Lagzdins on 16/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class CountryListTableViewController: UITableViewController {
    static let cellIdentifier = "country"
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Facts about Countries"

        // Hack to not show extra blank rows
        tableView.tableFooterView = UIView()
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.countries = self.loadCountries()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)

        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]

        guard let vc = storyboard?.instantiateViewController(identifier: "CountryDetailsTableViewController") as? CountryDetailsTableViewController else {
            fatalError("Could not initialize CountryDetailsTableViewController")
        }

        vc.country = country
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Loading Countries

    private func loadCountries() -> [Country] {
        let path = Bundle.main.path(forResource: "Countries", ofType: "json")!
        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Country].self, from: data)
        } catch {
            print("Could not load country list, \(error.localizedDescription)")
            return []
        }
    }
}
