//
//  DetailViewController.swift
//  Project7
//
//  Created by Maris Lagzdins on 11/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    var searchText: String?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }

        var htmlBody = detailItem.body

        if let searchText = searchText {
            htmlBody = htmlBody.replacingOccurrences(of: searchText, with: "<mark>\(searchText)</mark>")
        }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(htmlBody)
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}
