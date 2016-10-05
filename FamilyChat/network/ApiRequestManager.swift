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
    fileprivate let SERVER_URL = "http://localhost:5000/"
    
    fileprivate let API_LOGIN = "membership/login"
    fileprivate let API_JOIN = "membership/createId"

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
        
        let encodedBody = Utils.convertJsonStringWithDictionary(body)
        self.requestApi(API_LOGIN, body:encodedBody, completeHandler: {(resCode, responseBody) in
            if (resCode == 200) {
                compeleteHandler(true, responseBody)
            } else {
                compeleteHandler(false, nil)
            }
        })
    }
    
    func requestJoin(id:String?, pw:String?, completeHandler: @escaping (Bool, [String: AnyObject]?) -> Void) {
        if (ValidationUtils.isValid(id) == false || ValidationUtils.isValid(pw) == false) {
            print("Input id or password is empty")
            return completeHandler(false, nil)
        }
        
        let body: Dictionary<String, String> = ["id": id!, "password": pw!]
        let encodedBody = Utils.convertJsonStringWithDictionary(body)
        self.requestApi(API_JOIN, body: encodedBody) { (resCode, responseBody) in
            if (resCode == 200) {
                completeHandler(true, responseBody)
            } else {
                completeHandler(false, nil)
            }
        }
    }
}
