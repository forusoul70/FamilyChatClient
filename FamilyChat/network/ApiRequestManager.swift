//
//  ApiRequestManager.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 23..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

private let _sharedApiRequestManger = ApiRequestManager()

class ApiRequestManager: NSObject {
    
    private let SERVER_URL = "https://com-sanghwa-familychat.herokuapp.com/"
//    private let SERVER_URL = "http://localhost:8080/"
    
    private let API_LOGIN = "membership/login"

    class var shared : ApiRequestManager {
        return _sharedApiRequestManger
    }
    
    private func requestApi(api:String!, body:String!, completeHandler: (Int?, NSString?) -> Void) {
        let url = NSURL(string: SERVER_URL + api)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if (response == nil) {
                print("requestApi(), Failed to get response")
                return
            }
            
            let body:NSString!
            if (data == nil) {
                body = "Failed to get body from response"
            } else {
                body = NSString(data: data!, encoding: NSUTF8StringEncoding)
            }
            
            let resultCode = (response as! NSHTTPURLResponse).statusCode
            completeHandler(resultCode, body)
            
            print("APi [\(api)]")
            print("response [\(body)]")
        })
        task.resume()
    }
    
    func requestLogin(id:String!, password:String!, compeleteHandler: (Bool, NSString?) -> Void) {
        let body: Dictionary<String, String> = ["id": id, "password": password]
        do {
            let encodedBody = try NSString(data: NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted),
                encoding: NSUTF8StringEncoding) as! String
            
            self.requestApi(API_LOGIN, body:encodedBody, completeHandler: {(resCode, responseBody) in
                if (resCode == 201) {
                    compeleteHandler(true, responseBody)
                } else {
                    compeleteHandler(false, nil)
                }
            })
        } catch {
            abort()
        }
    }
}
