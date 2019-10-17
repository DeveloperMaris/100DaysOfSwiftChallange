//
//  ViewController.swift
//  Project16
//
//  Created by Maris Lagzdins on 17/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController {
    enum MapType: String {
        case standard = "Standard"
        case hybrid = "Hybrid"
        case sattelite = "Satellite"

        func convertToMKMapType() -> MKMapType {
            switch self {
            case .standard:
                return .standard
            case .hybrid:
                return .hybrid
            case .sattelite:
                return .satellite
            }
        }
    }

    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "World Map of Capital Cities"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(changeMapTypeTapped))

        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.50722, longitude: -0.1275), info: "Home to the 2012 Olympics.", wikipedia: URL(string: "https://en.wikipedia.org/wiki/London")!)
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", wikipedia: URL(string: "https://en.wikipedia.org/wiki/Oslo")!)
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", wikipedia: URL(string: "https://en.wikipedia.org/wiki/Paris")!)
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wikipedia: URL(string: "https://en.wikipedia.org/wiki/Rome")!)
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", wikipedia: URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C.")!)

        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }

    @objc
    private func changeMapTypeTapped() {
        let ac = UIAlertController(title: "Select map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: MapType.standard.rawValue, style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: MapType.hybrid.rawValue, style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: MapType.sattelite.rawValue, style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    @objc
    private func changeMapType(action: UIAlertAction) {
        guard let title = action.title, let mapType = MapType(rawValue: title) else { fatalError("Unsupported map type") }
        mapView.mapType = mapType.convertToMKMapType()
    }

    private func showInfo(about capital: Capital) {
        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))

        present(ac, animated: true)
    }

    private func openWebView(url: URL) {
        guard let wvc = storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController else {
            return
        }

        wvc.url = url
        navigationController?.pushViewController(wvc, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.pinTintColor = .green

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }

        // Alert
//        showInfo(about: capital)

        // Web view
        openWebView(url: capital.wikipedia)
    }
}
