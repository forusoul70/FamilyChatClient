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
    
//    private let SERVER_URL = "https://com-sanghwa-familychat.herokuapp.com/"
    private let SERVER_URL = "http://localhost:8080/"
    
    private let API_LOGIN = "membership/login"

    class var shared : ApiRequestManager {
        return _sharedApiRequestManger
    }
    
    private func requestApi(api:String!, body:String!, completeHandler: (Int?, [String : AnyObject]?) -> Void) {
        let url = NSURL(string: SERVER_URL + api)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if (response == nil || data == nil) {
                print("requestApi(), Failed to get response")
                return
            }
            
            let resultCode = (response as! NSHTTPURLResponse).statusCode
            var resJson:AnyObject!
            let body:NSString! = NSString(data: data!, encoding: NSUTF8StringEncoding)

            do {
                resJson = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                print("APi [\(api)]")
                print("response [\(body)]")
                
            } catch {
                let errorRes = ["error" : body]
                completeHandler(resultCode, errorRes)
                return
            }
            
            if (resJson != nil) {
                completeHandler(resultCode, resJson as? [String: AnyObject])
            } else {
                completeHandler(resultCode, nil)
            }
           
        })
        task.resume()
    }
    
    func requestLogin(id:String!, password:String!, compeleteHandler: (Bool, [String: AnyObject]?) -> Void) {
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
