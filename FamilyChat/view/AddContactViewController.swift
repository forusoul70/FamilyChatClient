//
//  AddContactViewController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 10. 13..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class AddContactViewController: BaseUIViewController {

    @IBOutlet weak var accoutTextView: UITextField!
    
    @IBAction func onSearchButtonClicked(_ sender: AnyObject) {
        let account = self.accoutTextView.text
        if (ValidationUtils.isValid(account) == false) {
            ValidationUtils.showAlertView("에러", message: "ID를 입력해주세요", clickTitle: "확인", viewController: self)
            return
        }
        
        showProgress()
        ApiRequestManager.shared.requestAddFriendAccount(account: account) { (result, responseBody) in
            DispatchQueue.main.async {
                self.hideProgress()
                if (result) {
                    ValidationUtils.showAlertView("에러", message: "성공하였습니다.", clickTitle: "확인", viewController: self)
                } else { // 성공
                    ValidationUtils.showAlertView("성공", message: "실패하였습니다.", clickTitle: "확인", viewController: self)
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
