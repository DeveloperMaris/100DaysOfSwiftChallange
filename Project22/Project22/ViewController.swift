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
    @IBOutlet var detectedBeacon: UILabel!

    var distanceIndicator: UIView!

    var isBeaconDetected = false
    var locationManager: CLLocationManager?

    var possibleBeacons = [
        CLBeaconRegion(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, /*major: 123, minor: 456,*/ identifier: "Apple AirLocate 5A4BCFCE"),
        CLBeaconRegion(uuid: UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!, /*major: 321, minor: 654,*/ identifier: "Radius Networks 2F234454"),
        CLBeaconRegion(uuid: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, identifier: "Null iBeacon")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
//        locationManager?.requestWhenInUseAuthorization()

        view.backgroundColor = .gray

        distanceIndicator = UIView()
        distanceIndicator.translatesAutoresizingMaskIntoConstraints = false
        distanceIndicator.layer.cornerRadius = 128
        distanceIndicator.backgroundColor = .green
        distanceIndicator.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        view.addSubview(distanceIndicator)

        NSLayoutConstraint.activate([
            distanceIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            distanceIndicator.widthAnchor.constraint(equalToConstant: 256),
            distanceIndicator.heightAnchor.constraint(equalToConstant: 256),
            distanceIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }

    func startScanning() {
//        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")! // Known test beacon assigned by Apple
//        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        for beaconRegion in possibleBeacons {
            locationManager?.startMonitoring(for: beaconRegion)
//            locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        }
    }

    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.distanceIndicator.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)

            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.distanceIndicator.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.distanceIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.distanceIndicator.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
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

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter", region)
        guard let beacon = region as? CLBeaconRegion else { return }
        locationManager?.startRangingBeacons(satisfying: beacon.beaconIdentityConstraint)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit", region)
        guard let beacon = region as? CLBeaconRegion else { return }
        locationManager?.stopRangingBeacons(satisfying: beacon.beaconIdentityConstraint)
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            detectedBeacon.text = possibleBeacons.first(where: { $0.uuid == beacon.uuid })?.identifier ?? "-"

            if !isBeaconDetected {
                isBeaconDetected = true

                let ac = UIAlertController(title: "Beacon detected", message: beacon.debugDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
            }
        }
//        else {
//            update(distance: .unknown)
//            detectedBeacon.text = "-"
//        }
    }
}
