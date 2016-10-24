//
//  MainTabBarController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 10. 25..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let friendTab = self.tabBar.items![0]
        friendTab.title = "친구"
        
        let conversationTab = self.tabBar.items![1]
        conversationTab.title = "대화"
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
