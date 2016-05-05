//
//  HTTPMock.swift
//  Trecco
//
//  Created by Joshua Johanan on 5/2/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import BrightFutures
@testable import Trecco

class HTTPMock: HTTPActions {
    var future: Future<NSData?, NSError>
    var futures: [String:Future<NSData?, NSError>] = [:]
    var headers: [String:String]?
    var params: [String:AnyObject]?
    var url: String?
    
    init(future: Future<NSData?, NSError>) {
        self.future = future
    }
    
    func matchURL(url: String) -> Future<NSData?, NSError> {
        if let route = self.futures[url] {
            return route
        }
        
        return self.future
    }
    
    func upload(url: String, headers: [String: String], file: NSURL) -> Future<NSData?, NSError> {
        self.url = url
        self.headers = headers
        return self.matchURL(url)
    }
    
    func get(url: String, parameters: [String: AnyObject]) -> Future<NSData?, NSError> {
        self.url = url
        self.params = parameters
        return self.matchURL(url)
    }
    
    func post(url: String, parameters: [String: AnyObject]) -> Future<NSData?, NSError> {
        self.url = url
        self.params = parameters
        return self.matchURL(url)
    }
}
