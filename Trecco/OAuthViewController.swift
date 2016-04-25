//
//  OAuthViewController.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/25/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import OAuthSwift

class OauthViewController: OAuthWebViewController, OAuthViewDelegate {
    
    var targetURL : NSURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let oauth = OAuthView()
        self.view = oauth
        oauth.setWebViewDelegateForWebView(self)
        oauth.delegate = self
    }
    
    override func handle(url: NSURL) {
        targetURL = url
        super.handle(url)
        
        (self.view as! OAuthView).loadWebRequest(url)
    }
    
    func dismissView() {
        self.dismissWebViewController()
    }
    
}

// MARK: delegate

extension OauthViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where (url.scheme == "co.ejosh.trecco"){
            self.dismissWebViewController()
        }
        return true
    }
}
