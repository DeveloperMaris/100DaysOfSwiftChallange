//
//  Capital.swift
//  Project16
//
//  Created by Maris Lagzdins on 17/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var wikipedia: URL

    init(title: String, coordinate: CLLocationCoordinate2D, info: String, wikipedia: URL) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wikipedia = wikipedia
    }
}
