//
//  ValidationUtils.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 13..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class ValidationUtils: NSObject {
    static func isValid(str:NSString?) -> Bool {
        if (str != nil && str?.length > 0) {
            return true
        }
        
        return false
    }
    
    static func showAlertView(title:String!, message:String!, clickTitle:String!, viewController:UIViewController!) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: clickTitle, style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}
