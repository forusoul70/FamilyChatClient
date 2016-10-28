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
    private let SERVER_URL = "http://localhost:5000/"
    
    private let API_LOGIN = "membership/login"
    private let API_JOIN = "membership/createId"
    private let API_ADD_FRIEND = "membership/addContactId"
    private let API_GET_PRORILE_IMAGE = "getProfile/"

    class var shared : ApiRequestManager {
        return _sharedApiRequestManger
    }
    
    private func requestApi(_ api:String!, body:String!, completeHandler: @escaping (Int?, [String : AnyObject]?) -> Void) {
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
    
    private func getResource(_ api:String!, completeHandler: @escaping (Int?, Data?) -> Void) {
        let url = URL(string: SERVER_URL + api)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            let resultCode = (response as! HTTPURLResponse).statusCode
            if (resultCode == 2000) {
                completeHandler(resultCode, data)
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
    
    func requestAddFriendAccount(account:String?, completeHandler: @escaping (Bool, [String: AnyObject]?) -> Void) {
        let curretUserId = CoreDataHelper.shared.getCurrentUserId()
        if (ValidationUtils.isValid(curretUserId) == false) {
            print("Failed to get current user id is empty")
            return
        }
        
        if (ValidationUtils.isValid(account) == false) {
            print("Input friend account is empty");
            return
        }
        
        let body:Dictionary<String,String> = ["id" : curretUserId, "friend" : account!]
        let encoedBody = Utils.convertJsonStringWithDictionary(body)
        self.requestApi(API_ADD_FRIEND, body: encoedBody) { (resCode, responseBody) in
            if (resCode == 200) {
                completeHandler(true, responseBody)
            } else {
                completeHandler(false, nil)
            }
        }
    }
    
    func reqeustProfileImage(account:String!, completeHandler: @escaping (Bool, Data?) -> Void) {
        if (ValidationUtils.isValid(account) == false) {
            print("reqeustProfileImage(), Inavlid account")
            return
        }
        
        let api = API_GET_PRORILE_IMAGE + account
        self.getResource(api) { (resCode, data) in
            if (resCode == 200) {
                completeHandler(true, data)
            } else {
                completeHandler(false, nil)
            }
        }
    }
}
