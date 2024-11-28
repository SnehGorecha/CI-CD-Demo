//
//  WebViewVC.swift
//  AddressFull
//
//  Created by Sneh on 28/08/24.
//

import UIKit
import WebKit

class WebViewVC: BaseViewController {
    
    @IBOutlet weak var web_view: WKWebView!
    @IBOutlet weak var navigation_bar: UIView!
    
    var web_view_title = ""
    var web_view_url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: web_view_title, isWithBackOption: true)
    }
    
    func setupUI() {
        if let url = URL(string: self.web_view_url) {
            self.web_view.load(URLRequest(url: url))
        }
    }
    
}
