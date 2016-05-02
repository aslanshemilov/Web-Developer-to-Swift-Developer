//
//  TrelloAPI.swift
//  Trecco
//
//  Created by Joshua Johanan on 5/1/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures

enum TrelloAPIError : ErrorType {
    case CardCreationError(String)
    case AFError(NSError)
}

class TrelloAPI {
    
    var key: String
    var token: String
    var apiBase: String = "https://api.trello.com/1"
    var http: HTTPActions!
    
    init(key: String, token: String, http: HTTPActions) {
        self.key = key
        self.token = token
        self.http = http
    }
    
    func getMe() -> Future<TrelloMember, NSError> {
        let promise = Promise<TrelloMember, NSError>()
        
        http.get("\(self.apiBase)/members/me", parameters: ["key" : self.key, "token" : self.token])
            .onSuccess{data in promise.success(ResponseMapping.ToTrelloMember(data)!)}
            .onFailure{error in promise.failure(error)}
        
        return promise.future
    }
    
    func getBoards() -> Future<[TrelloBoard], NSError> {
        let promise = Promise<[TrelloBoard], NSError>()
        
        http.get("\(self.apiBase)/members/me/boards", parameters: ["key" : self.key, "token" : self.token])
            .onSuccess{data in promise.success(try! ResponseMapping.ToTrelloBoardArray(data))}
            .onFailure{error in promise.failure(error)}
        
        return promise.future
    }
    
    func getListsForBoard(boardId: String) -> Future<[TrelloList], NSError> {
        let promise = Promise<[TrelloList], NSError>()
        
        http.get("\(self.apiBase)/boards/\(boardId)/lists", parameters: ["key" : self.key, "token" : self.token])
            .onSuccess{data in promise.success(try! ResponseMapping.ToTrelloListArray(data))}
            .onFailure{error in promise.failure(error)}
        
        return promise.future
    }
    
    func createCard(card: TrelloCreateCard) -> Future<TrelloCard, TrelloAPIError> {
        let promise = Promise<TrelloCard, TrelloAPIError>()
        
        http.post("\(self.apiBase)/cards?key=\(self.key)&token=\(self.token)",
            parameters: [
                "name": card.name,
                "due": NSNull(),
                "idList": card.idList,
                "urlSource": NSNull()])
            .onSuccess{data in
                let card = ResponseMapping.ToTrelloCard(data)
                if let card = card {
                    promise.success(card)
                    return
                }
                
                promise.failure(TrelloAPIError.CardCreationError("Card was not created"))
            }
            .onFailure{error in
                promise.failure(TrelloAPIError.AFError(error))
        }
        
        return promise.future
    }
    
    func getAllListsForAllBoards() -> Future<[TrelloBoardWithList], NSError> {
        let promise = Promise<[TrelloBoardWithList], NSError>()
        
        self.getBoards()
            .onSuccess{boards in
                let openBoards = boards.filter({$0.closed == false})
                let count = openBoards.count
                var i = 0
                var trelloBoards: [TrelloBoardWithList] = []
                
                for(board):(TrelloBoard) in openBoards {
                    self.getListsForBoard(board.id)
                        .onSuccess{list in
                            trelloBoards.append(TrelloBoardWithList(board: board, list: list.filter({$0.closed == false})))
                            i++
                            if(count == i) {promise.success(trelloBoards)}
                        }
                        .onFailure{error in promise.failure(error)}
                }
                
            }
            .onFailure{error in
                promise.failure(error)
        }
        
        
        return promise.future
    }
}
