//
//  InputValidator.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit

class InputValidator {
    
}

extension InputValidator {
    // 判断字符串是否符合语法法则
    class func isValidEmail(_ email: String) -> Bool {
        let regular = try? NSRegularExpression(pattern: "^\\S+@\\S+\\.\\S+$", options: [])
        if let re = regular {
            let range = NSRange(location: 0, length: email.lengthOfBytes(using: .utf8))
            let result = re.matches(in: email, options: [], range: range)
            return result.count > 0
        }
        return false
    }
    
    // 判断密码个数>8
    class func isValidPassword(_ password: String) -> Bool {
        return password.count > 5
    }
    
    // 判断用户名
    class func validateUserName(_ username: String) -> Result {
        // 判断字符个数是否正确
        if username.count < 6 {
            return Result.failture(message: "输入的字符个数不能少于6个字符")
        }
        
        // 帐号可用
        return Result.success(message: "帐号可用")
    }
    
    // 检测密码
    class func validatePassword(_ password: String) -> Result {
        if password.count < 6 {
            return Result.failture(message: "输入密码不能少于6个字符")
        }
        
        return Result.success(message: "密码可用")
    }
    
    // 判断登录时的帐号和密码是否一致
    class func validateRepeatPassword(_ password: String, _ repeatPassword: String) -> Result {
        if password == repeatPassword && !password.isEmpty && !repeatPassword.isEmpty {
            return Result.success(message: "两次输入的密码一致")
        }
        
        return Result.failture(message: "两次输入的密码不一致")
    }
    
    // 判断是否可以注册成功
    class func validateRegisterSuccess(_ username: Result, _ password: Result, _ repeatPassword: Result) -> Result {
        if username.isValid && password.isValid && repeatPassword.isValid {
            return Result.success(message: "注册成功")
        }
        
        return Result.failture(message: "注册是失败")
    }
}
