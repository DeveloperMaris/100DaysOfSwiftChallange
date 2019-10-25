//
//  ViewController.swift
//  Project22
//
//  Created by Maris Lagzdins on 25/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController {
    @IBOutlet var distanceReading: UILabel!

    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
//        locationManager?.requestWhenInUseAuthorization()

        view.backgroundColor = .gray
    }

    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")! // Known test beacon assigned by Apple
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }

    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"

            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"

            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"

            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) { // Can this thing detect if beacon exists
                if CLLocationManager.isRangingAvailable() { // Can we detect how far away beacon is to us
                    startScanning()
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}
