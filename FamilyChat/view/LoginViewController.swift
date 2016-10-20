//
//  LoginViewController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 11..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class LoginViewController: BaseUIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPassswordInfo: UILabel!
    
    private let loginSegueId = "loginSegue"
    private let joinSegueId = "joinSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.checkPassswordInfo.isHidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onJoinButtonClicked(_ sender: AnyObject) {
        self.performSegue(withIdentifier: self.joinSegueId, sender: sender)
    }
    
    @IBAction func onLoginButtonClickd(_ sender: AnyObject) {
        let id = self.idTextField.text
        let password = self.passwordTextField.text
        
        if (ValidationUtils.isValid(id) == false || ValidationUtils.isValid(password) == false) {
            ValidationUtils.showAlertView("에러", message: "아이디와 패스워드를 입력해주세요", clickTitle: "확인", viewController: self)
            return
        }
        
        showProgress()
        ApiRequestManager.shared.requestLogin(id, password: password, compeleteHandler: {(result, body) in
            
            if (result) {
                CoreDataHelper.shared.setAccountId(id) // save current user id
                DispatchQueue.main.async {
                    self.hideProgress()
                    self.performSegue(withIdentifier: self.loginSegueId, sender: sender)
                    let accountId = CoreDataHelper.shared.getCurrentUserId()
                    SocketIOManager.shared.requestRegiestAccountId(account: accountId)
                }
            } else {
                DispatchQueue.main.async {
                    self.hideProgress()
                    ValidationUtils.showAlertView("에러", message: "아이디나 패스워드가 틀립니다", clickTitle: "확인", viewController: self)
                }
            }
        })
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if (identifier == self.loginSegueId) {
//            SocketIOManager.shared.requestRegiestAccountId(account: "test")
//        }
//        return true
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
