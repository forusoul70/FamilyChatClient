//
//  DevMenuController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 13..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class DevMenuController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameEditText: UITextField!
    @IBOutlet weak var bodyEditText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    @IBAction func onAddMessageButtonClicked(sender: AnyObject) {
        // Get input text
        let name = self.nameEditText.text;
        let message = self.bodyEditText.text;
        
        if (ValidationUtils.isValid(name) == false || ValidationUtils.isValid(message) == false) {
            return
        }
        
        let insertedItem:Message = CoreDataHelper.insertMessage(name, body: message, isSend: false)
        insertedItem.isSend = false        
    }
}
