//
//  RegisterViewModel.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift

class RegisterViewModel {
    
    var username = Variable("")
    var password = Variable("")
    var repeatPassword = Variable("")
    
    var usernameObservable: Observable<Result>
    var passwordObservable: Observable<Result>
    var repeatPasswordObservable: Observable<Result>
    var registerBtnObservable: Observable<Bool>
    
    init() {
        // 检测帐号
        usernameObservable = username.asObservable().map({ (username) -> Result in
            return InputValidator.validateUserName(username)
        })
        
        // 检测密码
        passwordObservable = password.asObservable().map({ (password) -> Result in
            return InputValidator.validatePassword(password)
        })
        
        // 检测密码和重置密码
        repeatPasswordObservable = Observable.combineLatest(password.asObservable(), repeatPassword.asObservable(), resultSelector: { (password, repeatPassword) -> Result in
            return InputValidator.validateRepeatPassword(password, repeatPassword)
        })
        
        // 检测注册是否成功
        registerBtnObservable = Observable.combineLatest(usernameObservable, passwordObservable, repeatPasswordObservable, resultSelector: { (username, password, repeatPassword) -> Bool in
            return InputValidator.validateRegisterSuccess(username, password, repeatPassword).isValid
        })
    }
}
