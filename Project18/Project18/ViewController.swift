//
//  ViewController.swift
//  Project18
//
//  Created by Maris Lagzdins on 18/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Debugging with "print"
//        print("I'm inside the viewDidLoad() method.")
//        print(1, 2, 3, 4, 5)
//        print(1, 2, 3, 4, 5, separator: "-")
//        print("Some message", terminator: "")
//        print("Some message again", "And again", separator: "-", terminator: "")

        // Debugging with "assert"
//        assert(1 == 1, "Math failure!")
//        assert(1 == 2, "Math failure!")
////        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing.")

        // Debugging with "breakpoints"
        for i in 1...100 {
            print("Got number \(i)")
        }
    }
}
