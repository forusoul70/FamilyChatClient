//
//  JoinViewController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 10. 4..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class JoinViewController: BaseUIViewController {
    @IBOutlet weak var idEditText: UITextField!
    @IBOutlet weak var passwordEditText: UITextField!
    @IBOutlet weak var passwordConfirmEditText: UITextField!
    @IBOutlet weak var JoinButton: UIButton!
    
    @IBAction func onJoinButtonClicked(_ sender: AnyObject) {
        let id = self.idEditText.text
        let pw = self.passwordEditText.text
        let pwConfirm = self.passwordConfirmEditText.text
        
        if (ValidationUtils.isValid(id) == false) {
            ValidationUtils.showAlertView("error", message: "ID를 입력해주세요.", clickTitle: "확인", viewController: self)
            return
        }
        
        if (ValidationUtils.isValid(pw) == false) {
            ValidationUtils.showAlertView("error", message: "패스워드를 입력해주세요.", clickTitle: "확인", viewController: self)
            return
        }
        
        if (ValidationUtils.isValid(pwConfirm) == false) {
            ValidationUtils.showAlertView("error", message: "패스워드 확인을 입력해주세요.", clickTitle: "확인", viewController: self)
            return
        }
        
        if (pw != pwConfirm) {
            ValidationUtils.showAlertView("error", message: "입력한 패스워드가 다릅니다.", clickTitle: "확인", viewController: self)
            return
        }
        
        showProgress()
        ApiRequestManager.shared.requestJoin(id: id, pw: pw) { (result, responseBody) in
            if (result)  {
                DispatchQueue.main.sync {
                    self.hideProgress()
                    ValidationUtils.showAlertView("Join", message: "가입하였습니다", clickTitle: "확인", viewController: self) { (alertAction) in
                        self.navigationController!.popViewController(animated: true)
                    }
                }
            } else {
                DispatchQueue.main.sync {
                    self.hideProgress()
                    ValidationUtils.showAlertView("Join", message: "가입 실패하였습니다.", clickTitle: "확인", viewController: self)
                }                
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
