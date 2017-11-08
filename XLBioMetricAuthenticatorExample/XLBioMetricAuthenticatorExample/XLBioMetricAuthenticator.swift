//
//  XLTouchID.swift
//  XLTouchID
//
//  Created by xx11dragon on 2017/11/6.
//  Copyright © 2017年 xx11dragon.All rights reserved.
//

import UIKit
import LocalAuthentication


public class XLBioMetricAuthenticator {
    // MARK:- Class method
    //  默认 Biometrics or passcode
    private var policy: LAPolicy = .deviceOwnerAuthentication

    public class var biometrics: XLBioMetricAuthenticator {
        let authenticator = XLBioMetricAuthenticator()
        authenticator.policy = .deviceOwnerAuthenticationWithBiometrics
        return authenticator
    }

    public class var biometricsOrPasscode: XLBioMetricAuthenticator {
        let authenticator = XLBioMetricAuthenticator()
        authenticator.policy = .deviceOwnerAuthentication
        return authenticator
    }
    
    init(_ policy: LAPolicy) {
        self.policy = policy
    }
    
    private init() {}
    
    // MARK:- Public method
    
    //  Block 验证成功
    public typealias AuthenticationSuccess = (() -> ())
    //  Block 验证失败
    public typealias AuthenticationFailure = ((Error) -> ())
    //  是否支持验证
    public var canAuthenticate: (value: Bool, error: Error?) {
        var error: NSError? = nil
        let value = LAContext().canEvaluatePolicy(policy, error: &error)
        let resultError = error is LAError ? Error(error as! LAError) : nil
        return (value, resultError)
    }
    //  验证
    public func authenticate(reason: String,
                             fallbackTitle: String? = nil,
                             cancelTitle: String? = nil,
                             success successBlock: AuthenticationSuccess?,
                             failure failureBlock: AuthenticationFailure?) {
        let context = LAContext()
        if #available(iOS 10.0, *) {    //  iOS10 之后可以设置
            context.localizedCancelTitle = cancelTitle
        }
        context.localizedFallbackTitle = fallbackTitle
        context.evaluatePolicy(policy, localizedReason: reason, reply: { (success, error) in
            if success { successBlock  != nil ? successBlock!() : () }
            if let laerror = error as? LAError {
                failureBlock  != nil ? failureBlock!(Error(laerror)) : ()
            }
        })
    }
    
    //  FaceID是否可用
    public var faceIDAvailable: Bool {
        if #available(iOS 11.0, *) {
            return LAContext().biometryType == .typeFaceID
        }
        return  false
    }
    
}

extension XLBioMetricAuthenticator {
    public struct Error {
        public enum Code : Int {
            case appCancel              // 程序取消
            case authenticationFailed   // 验证失败
            case biometryLockout        // 用户错误次数太多，现在被锁住了
            case biometryNotAvailable   // 用户设备不支持TouchID
            case biometryNotEnrolled    // 用户没有设置手指指纹
            case invalidContext         // 请求验证出错
            case userCancel             // 用户取消了验证
            case userFallback           // 用户点击了输入密码
            case systemCancel           // 被系统取消，就是说你现在进入别的应用了，不在刚刚那个页面，所以没法验证
            case passcodeNotSet         // 用户没有设置Passcode
            case notInteractive         // 无法交互
            case other                  // 其他
        }
        
        var code: Code = .other
                
        init(_ error: LAError) {
            switch error.code.rawValue {
            case LAError.appCancel.rawValue:
                code = .appCancel
            case LAError.authenticationFailed.rawValue:
                code = .authenticationFailed
            case LAError.invalidContext.rawValue:
                code = .invalidContext
            case LAError.userCancel.rawValue:
                code = .userCancel
            case LAError.userFallback.rawValue:
                code = .userFallback
            case LAError.systemCancel.rawValue:
                code = .systemCancel
            case LAError.passcodeNotSet.rawValue:
                code = .passcodeNotSet
            case LAError.notInteractive.rawValue:
                code = .notInteractive
            case Int(kLAErrorBiometryNotAvailable):
                code = .biometryNotAvailable
            case Int(kLAErrorBiometryNotEnrolled):
                code = .biometryNotEnrolled
            case Int(kLAErrorBiometryLockout):
                code = .biometryLockout
            default:
                code = .other
            }
        }
    }
}



