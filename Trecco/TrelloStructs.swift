//
//  TrelloStructs.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/28/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation

struct TrelloMember {
    var id: String
    var avatarHash: String
    var fullName: String
}

struct TrelloBoard {
    var name: String
    var closed: Bool
    var id: String
    
}

struct TrelloBoardWithList {
    var board: TrelloBoard
    var list: [TrelloList]
}

struct TrelloList {
    var id: String
    var name: String
    var idBoard: String
    var closed: Bool
}

struct TrelloCard {
    var id: String
    var name: String
    var desc: String
    var shortUrl: String
    var idBoard: String
    var idList: String
}

struct TrelloCreateCard {
    var idList: String
    var name: String
}
