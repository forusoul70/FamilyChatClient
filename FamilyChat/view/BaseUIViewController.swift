//
//  BaseUIViewController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 23..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    private var progressView:UIActivityIndicatorView? = nil
    
    func showProgress() {
        if (self.progressView == nil) {
            let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            indicator.center = view.center

            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.progressView = indicator
        }
        
        self.view.addSubview(self.progressView!)
        self.progressView?.bringSubviewToFront(view)
        self.progressView?.startAnimating()
        self.progressView?.hidden = false
    }
    
    func hideProgress() {
        if (self.progressView != nil) {
            self.view.sendSubviewToBack(self.progressView!)
            self.progressView!.hidden = true;
            self.progressView!.stopAnimating()
            self.progressView!.removeFromSuperview()
        }
        
    }
}
