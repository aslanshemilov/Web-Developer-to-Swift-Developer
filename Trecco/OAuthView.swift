//
//  OAuthView.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/25/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit

protocol OAuthViewDelegate {
    func dismissView()
}


class OAuthView: BaseView {
    @IBOutlet var webView: UIWebView!
    var delegate: OAuthViewDelegate?
    var webViewDelegate: UIWebViewDelegate?
    
    func setWebViewDelegateForWebView(delegate: UIWebViewDelegate) {
        self.webView.delegate = delegate
    }
    
    func loadWebRequest(url: NSURL) {
        let req = NSURLRequest(URL: url)
        self.webView.loadRequest(req)
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.delegate?.dismissView()
    }
}

