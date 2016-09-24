//
//  ValidationUtils.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 13..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class ValidationUtils: NSObject {
    static func isValid(_ str:String?) -> Bool {
        if (str != nil && str!.characters.count > 0) {
            return true
        }
        
        return false
    }
    
    static func showAlertView(_ title:String!, message:String!, clickTitle:String!, viewController:UIViewController!) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: clickTitle, style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
