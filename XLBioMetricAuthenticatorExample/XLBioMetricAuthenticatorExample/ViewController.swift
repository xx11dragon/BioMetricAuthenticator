//
//  ViewController.swift
//  XLBioMetricAuthenticatorExample
//
//  Created by xx11dragon on 2017/11/8.
//  Copyright © 2017年 xx11dragon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let leftButton = UIButton(type: .system)
        leftButton.setTitle("生物识别", for: .normal)
        leftButton.addTarget(self, action: #selector(biometrics), for: .touchUpInside)
        leftButton.frame = CGRect(x: 10, y: 100, width: 150, height: 50)
        view.addSubview(leftButton)
        
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("生物识别或密码", for: .normal)
        rightButton.addTarget(self, action: #selector(biometricsOrPasscode), for: .touchUpInside)
        rightButton.frame = CGRect(x: 10, y: 200, width: 150, height: 50)
        view.addSubview(rightButton)
        
        
        
        
    }
    
    @objc private func biometricsOrPasscode() {
        let canAuthenticate = XLBioMetricAuthenticator.biometrics.canAuthenticate
        if canAuthenticate.value {
            XLBioMetricAuthenticator.biometricsOrPasscode.authenticate(reason: "验证用于登录", success: {
                print("成功")
            }, failure: { (error) in
                print(error.code)
            })
        }
    }
    
    @objc private func biometrics() {
        let canAuthenticate = XLBioMetricAuthenticator.biometrics.canAuthenticate
        if canAuthenticate.value {
            XLBioMetricAuthenticator.biometrics.authenticate(reason: "验证用于登录", success: {
                print("成功")
            }, failure: { (error) in
                if error.code == .userFallback {
                    print("需要进入自定义输入密码界面")
                }
                print(error.code)
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
