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
    fileprivate let SERVER_URL = "http://localhost:8080/"
    
    fileprivate let API_LOGIN = "membership/login"

    class var shared : ApiRequestManager {
        return _sharedApiRequestManger
    }
    
    fileprivate func requestApi(_ api:String!, body:String!, completeHandler: @escaping (Int?, [String : AnyObject]?) -> Void) {
        let url = URL(string: SERVER_URL + api)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = body.data(using: String.Encoding.utf8)        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if (response == nil || data == nil) {
                print("requestApi(), Failed to get response")
                completeHandler(500, nil)
                return
            }
            
            let resultCode = (response as! HTTPURLResponse).statusCode
            var resJson:Any!
            let body:String! = String(data: data!, encoding: String.Encoding.utf8)

            do {
                resJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                
                print("APi [\(api)]")
                print("response [\(body)]")
                
            } catch {
                let errorRes = ["error" : body]
                completeHandler(resultCode, errorRes as [String : AnyObject])
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
    
    func requestLogin(_ id:String!, password:String!, compeleteHandler: @escaping (Bool, [String: AnyObject]?) -> Void) {
        let body: Dictionary<String, String> = ["id": id, "password": password]
        do {
            let encodedBody = try NSString(data: JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted),
                encoding: String.Encoding.utf8.rawValue) as! String
            
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
