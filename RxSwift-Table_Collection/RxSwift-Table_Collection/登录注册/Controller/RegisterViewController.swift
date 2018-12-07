//
//  RegisterViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameHintLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordHintLabel: UILabel!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var passwordRepeatLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    fileprivate lazy var registerVM = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "注册"
        
        // 1. 帐号判断逻辑
        // 1-1. 检测帐号
        usernameTextField.rx.text
            .orEmpty
            .bind(to: registerVM.username)
            .disposed(by: bag)
        
        // 1-2. 根据帐号监听提示字体的状态
        registerVM.usernameObservable
            .bind(to: usernameHintLabel.rx.validationResult)
            .disposed(by: bag)
        
        // 1-3. 根据帐号监听密码输入框的状态
        registerVM.usernameObservable
            .bind(to: passwordTextField.rx.enableResult)
            .disposed(by: bag)
        
        
        // 2. 密码判断逻辑
        passwordTextField.rx.text
            .orEmpty
            .bind(to: registerVM.password)
            .disposed(by: bag)
        
        // 2-1. 根据密码字符串监听密码提示信息的显示状态
        registerVM.passwordObservable
            .bind(to: passwordHintLabel.rx.validationResult)
            .disposed(by: bag)
        
        // 2-2. 根据密码字符串监听密码重复密码输入框的状态
        registerVM.passwordObservable
            .bind(to: passwordRepeatTextField.rx.enableResult)
            .disposed(by: bag)
        
        
        // 3. 重复输入密码逻辑
        passwordRepeatTextField.rx.text
            .orEmpty
            .bind(to: registerVM.repeatPassword)
            .disposed(by: bag)
        
        // 3-1. 根据重复密码字符串监听密码提示信息的显示状态
        registerVM.repeatPasswordObservable
            .bind(to: passwordRepeatLabel.rx.validationResult)
            .disposed(by: bag)
        
        
        // 4. 处理按钮点击事件
        // 4-1. 按钮的状态(是否可点)
        registerVM.registerBtnObservable
            .bind(to: registerBtn.rx.isEnabled)
            .disposed(by: bag)
        
        registerVM.registerBtnObservable
            .bind(to: registerBtn.rx.backColorResult)
            .disposed(by: bag)
        
        // 4-2. 监听注册按钮的点击
        registerBtn.rx.tap
            .subscribe({ (_) in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: bag)
    }
    
}
