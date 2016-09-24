//
//  BaseUIViewController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 23..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    fileprivate var progressView:UIActivityIndicatorView? = nil
    
    func showProgress() {
        if (self.progressView == nil) {
            let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
            indicator.center = view.center
            self.progressView = indicator
        }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.view.addSubview(self.progressView!)
        self.progressView?.bringSubview(toFront: view)
        self.progressView?.startAnimating()
        self.progressView?.isHidden = false
    }
    
    func hideProgress() {
        if (self.progressView != nil) {
            self.view.sendSubview(toBack: self.progressView!)
            self.progressView!.isHidden = true;
            self.progressView!.stopAnimating()
            self.progressView!.removeFromSuperview()
        }
       
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
