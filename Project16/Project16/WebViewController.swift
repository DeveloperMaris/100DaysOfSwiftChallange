//
//  WebViewController.swift
//  Project16
//
//  Created by Maris Lagzdins on 17/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import WebKit
import UIKit

class WebViewController: UIViewController {
    var webView: WKWebView { view as! WKWebView }
    var url: URL!

    override func loadView() {
        view = WKWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(url != nil, "URL is required")

        let request = URLRequest(url: url)
        webView.load(request)
    }
}
