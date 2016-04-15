//
//  TrelloAccount.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/13/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation

public protocol UserDefaultsProtocol {
    func stringForKey(defaultName: String) -> String?
    func setObject(value: AnyObject?, forKey: String)
    func removeObjectForKey(defaultName: String)
}

public class TrelloAccount {
    var defaults: UserDefaultsProtocol!
    
    init(defaultObject: UserDefaultsProtocol) {
        defaults = defaultObject
    }
    
    func isTrelloConnected() ->Bool {
        let token = defaults.stringForKey(GlobalConstants.TRELLO_TOKEN)
        if token != nil && token != "" {
            return true
        }else{
            return false
        }
    }
    
    func getTrelloAccountToken() -> String? {
        return defaults.stringForKey(GlobalConstants.TRELLO_TOKEN)
    }
    
    func getTrelloAvatarHashURL(avatarURL: String) -> String? {
        let avatarHash = defaults.stringForKey(GlobalConstants.TRELLO_AVATAR)
        return "\(avatarURL)\(avatarHash!)/50.png"
    }
    
    func getTrelloName() -> String? {
        return defaults.stringForKey(GlobalConstants.TRELLO_NAME)
    }
    
    func setTrelloAccountToken(token: String) {
        defaults.setObject(token, forKey: GlobalConstants.TRELLO_TOKEN)
    }
    
    func setTrelloAvatarHash(avatarHash: String) {
        defaults.setObject(avatarHash, forKey: GlobalConstants.TRELLO_AVATAR)
    }
    
    func setTrelloName(name: String) {
        defaults.setObject(name, forKey: GlobalConstants.TRELLO_NAME)
    }
    
    func removeTrello() {
        defaults.removeObjectForKey(GlobalConstants.TRELLO_TOKEN)
        defaults.removeObjectForKey(GlobalConstants.TRELLO_NAME)
        defaults.removeObjectForKey(GlobalConstants.TRELLO_AVATAR)
    }
}
