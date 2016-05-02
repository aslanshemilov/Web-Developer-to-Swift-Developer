//
//  WatsonSTT.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/30/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import BrightFutures


class WatsonSTT {
    var username: String?
    var password: String?
    var http: HTTPActions!
    
    init(username: String, password: String, http: HTTPActions){
        self.username = username
        self.password = password
        self.http = http
    }
    
    func credentialsToBase64() ->String {
        let utf8 = "\(self.username!):\(self.password!)".dataUsingEncoding(NSUTF8StringEncoding)
        return utf8!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    func processFileURL(fileURL: NSURL) -> Future<WatsonResults?, NSError> {
        let promise = Promise<WatsonResults?, NSError>()
        
        let headers = [
            "Content-Type" : "audio/l16;rate=16000;channels=1",
            "Transfer-Encoding" : "chunked",
            "Authorization": "Basic \(self.credentialsToBase64())"
        ]
        
        http.upload("https://stream.watsonplatform.net/speech-to-text/api/v1/recognize", headers: headers, file: fileURL)
            .onSuccess{data in promise.success(ResponseMapping.ToWatsonResults(data)) }
            .onFailure{error in promise.failure(error)}
        
        return promise.future
    }
}
