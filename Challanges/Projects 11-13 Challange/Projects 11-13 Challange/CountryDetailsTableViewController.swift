//
//  CountryDetailsTableViewController.swift
//  Projects 11-13 Challange
//
//  Created by Maris Lagzdins on 16/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class CountryDetailsTableViewController: UITableViewController {
    @IBOutlet private var landAreaLabel: UILabel!
    @IBOutlet private var waterAreaLabel: UILabel!
    @IBOutlet private var totalAreaLabel: UILabel!
    @IBOutlet private var notesLabel: UILabel!

    var country: Country!

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(country != nil, "Country object is required!")

        tableView.tableFooterView = UIView()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        title = country.name

        landAreaLabel.text = formatMeasurement(country.size.land)
        waterAreaLabel.text = formatMeasurement(country.size.water)
        totalAreaLabel.text = formatMeasurement(country.size.total)

        notesLabel.text = country.note ?? "-"
    }

    @objc
    func shareTapped() {
        let vc = UIActivityViewController(activityItems: [country.name, country.note ?? "No info"], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    private func formatMeasurement(_ size: Int) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        return formatter.string(from: Measurement(value: Double(size), unit: UnitArea.squareKilometers))
    }
}
