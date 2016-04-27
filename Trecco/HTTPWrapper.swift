//
//  HTTPWrapper.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/25/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures

protocol HTTPActions {
    func upload(url: String, headers: [String: String], file: NSURL) -> Future<NSData?, NSError>
    func get(url: String, parameters: [String: AnyObject]) -> Future<NSData?, NSError>
    func post(url: String, parameters: [String: AnyObject]) -> Future<NSData?, NSError>
}

class HTTP: HTTPActions {
    
    func upload(url: String, headers: [String : String], file: NSURL) -> Future<NSData?, NSError> {
        let promise = Promise<NSData?, NSError>()
        
        Alamofire.upload(.POST, url, headers: headers, file: file)
            .response(completionHandler: {request, response, data, error in
                if let error = error {
                    promise.failure(error)
                }
                
                promise.success(data)
            })
        
        return promise.future
    }
    
    func get(url: String, parameters: [String : AnyObject]) -> Future<NSData?, NSError> {
        let promise = Promise<NSData?, NSError>()
        Alamofire.request(.GET, url, parameters: parameters)
            .response(completionHandler: { request, response, data, error in
                if let error = error {
                    promise.failure(error)
                }
                
                promise.success(data)
            })
        
        return promise.future
    }
    
    func post(url: String, parameters: [String : AnyObject]) -> Future<NSData?, NSError> {
        let promise = Promise<NSData?, NSError>()
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .response(completionHandler: { request, response, data, error in
                if let error = error {
                    promise.failure(error)
                }
                
                promise.success(data)
            })
        
        return promise.future
    }
}
