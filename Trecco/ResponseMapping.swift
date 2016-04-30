//
//  ResponseMapping.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/28/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResponseMapping {
    
    static func ToWatsonResults(data: NSData?) -> WatsonResults? {
        if (data == nil) {return nil}
        
        let json = JSON(data: data!)
        
        let index = json["result_index"].intValue
        let result = json["results"][index]["alternatives"][0]
        let results = WatsonResults(
            result_index: index,
            transcript: result["transcript"].stringValue,
            confidence: result["confidence"].doubleValue)
        
        return results
    }
    
    static func ToTrelloMember(data: NSData?) -> TrelloMember? {
        if (data == nil) {return nil}
        
        let json = JSON(data: data!)
        
        let me = TrelloMember(
            id: json["id"].stringValue,
            avatarHash: json["avatarHash"].stringValue,
            fullName: json["fullName"].stringValue)
        
        return me
    }
    
    static func ToTrelloBoard(data: NSData?) -> TrelloBoard? {
        if (data == nil) {return nil}
        
        let json = JSON(data: data!)
        
        let board = TrelloBoard(
            name: json["name"].stringValue,
            closed: json["closed"].boolValue,
            id: json["id"].stringValue)
        
        return board
    }
    
    static func ToTrelloBoardArray(data: NSData?) throws -> [TrelloBoard] {
        if (data == nil) {return []}
        
        let json = JSON(data: data!)
        
        return try json.arrayValue.flatMap({board in try ResponseMapping.ToTrelloBoard(board.rawData())})
    }
    
    static func ToTrelloList(data: NSData?) -> TrelloList? {
        if (data == nil) {return nil}
        
        let json = JSON(data: data!)
        
        let list = TrelloList(
            id: json["id"].stringValue,
            name: json["name"].stringValue,
            idBoard: json["idBoard"].stringValue,
            closed: json["closed"].boolValue)
        
        return list
    }
    
    static func ToTrelloListArray(data: NSData?) throws -> [TrelloList] {
        if (data == nil) {return []}
        
        let json = JSON(data: data!)
        
        return try json.arrayValue.flatMap({list in try ResponseMapping.ToTrelloList(list.rawData())})
        
    }
    
    static func ToTrelloCard(data: NSData?) -> TrelloCard? {
        if (data == nil) {return nil}
        
        let json = JSON(data: data!)
        
        let card = TrelloCard(id: json["id"].stringValue,
            name: json["name"].stringValue,
            desc: json["desc"].stringValue,
            shortUrl: json["shortUrl"].stringValue,
            idBoard: json["idBoard"].stringValue,
            idList: json["idList"].stringValue)
        
        return card
    }
}
