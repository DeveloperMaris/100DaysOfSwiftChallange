//
//  MainCoordinator.swift
//  Projects 28-30 Challange
//
//  Created by Maris Lagzdins on 11/11/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class MainCoordinator {
    var navigationController: UINavigationController

    init() {
        self.navigationController = UINavigationController()
    }

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
            fatalError("Could not load ViewController")
        }
        navigationController.pushViewController(vc, animated: false)
    }
}
