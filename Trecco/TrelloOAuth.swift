//
//  TrelloOAuth.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/25/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import OAuthSwift

class TrelloOAuth {
    var apiKey: String!
    var apiSecret: String!
    
    init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    func authenticate(urlHandler: OAuthSwiftURLHandlerType,
        completionHandler: (token: String?, error: ErrorType?) -> ()) {
        var cookieProps = [String:AnyObject]()
        
        cookieProps[NSHTTPCookieName] = "mobileApp"
        cookieProps[NSHTTPCookieValue] = "1"
        cookieProps[NSHTTPCookieDomain] = ".trello.com"
        cookieProps[NSHTTPCookiePath] = "/"
        cookieProps[NSHTTPCookieSecure] = true
        
        let cookie = NSHTTPCookie(properties: cookieProps)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie!)
        
        let mainBundle = NSBundle.mainBundle()
        let trelloRequestToken = mainBundle.objectForInfoDictionaryKey("TRELLO_API_REQUEST_TOKEN_URL") as! String
        let trelloAuthorize = mainBundle.objectForInfoDictionaryKey("TRELLO_API_AUTHORIZE_URL") as! String
        let trelloAccessToken = mainBundle.objectForInfoDictionaryKey("TRELLO_API_ACCESS_TOKEN_URL") as! String
        
        let oauthSwift = OAuth1Swift(
            consumerKey: self.apiKey,
            consumerSecret: self.apiSecret,
            requestTokenUrl: trelloRequestToken,
            authorizeUrl: trelloAuthorize,
            accessTokenUrl: trelloAccessToken)
        
        oauthSwift.authorize_url_handler = urlHandler
        
        oauthSwift.authorizeWithCallbackURL(
            NSURL(string:"co.ejosh.Trecco://oauth-callback/trello")!,
            success: { (credential, response, parameters) -> Void in
                completionHandler(token: credential.oauth_token, error: nil)
            }) { (error) -> Void in
                completionHandler(token: nil, error: error)
        }
        
    }
}
