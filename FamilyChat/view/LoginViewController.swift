//
//  LoginViewController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 11..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPassswordInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.checkPassswordInfo.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButtonClickd(sender: AnyObject) {
     
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "login") {
            let id = self.idTextField.text;
            let password = self.passwordTextField.text;
        
            // TODO : FIXME
            if (id == "test" && password == "1234") {
                return true;
            }
        
            self.checkPassswordInfo.hidden = false;
            return false;
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
