//
//  LoginViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航栏
        setupNavigationBar()
        
        // 2.监听帐号密码输入是否正确
        setupInputView()
        
        // 3.设置登录按钮的状态
        setupLoginButton()
    }
}

extension LoginViewController {
    fileprivate func setupNavigationBar() {
        navigationItem.title = "登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(exitItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerItemClick))
    }
    
    @objc fileprivate func exitItemClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func registerItemClick() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    fileprivate func setupInputView() {
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.cornerRadius = 5;
        usernameTextField.layer.masksToBounds = true
        passwordTextField.layer.borderWidth = 1
        
        let userObservable = usernameTextField.rx.text.map({ InputValidator.isValidEmail($0!) })
        userObservable.map({ $0 ? UIColor.green : UIColor.clear})
            .subscribe(onNext: {self.usernameTextField.layer.borderColor = $0.cgColor})
            .disposed(by: bag)
        
        let passObservable = passwordTextField.rx.text.map({ InputValidator.isValidPassword($0!) })
        passObservable.map({ $0 ? UIColor.green : UIColor.clear} )
            .subscribe(onNext: { self.passwordTextField.layer.borderColor = $0.cgColor})
            .disposed(by: bag)
        
        Observable.combineLatest(userObservable, passObservable) { (validUser, validPass) -> Bool in
            return validUser && validPass
            }.subscribe(onNext: { (isEnable) in
                self.loginBtn.isEnabled = isEnable
            }).disposed(by: bag)
    }
    
    fileprivate func setupLoginButton() {
        
    }
}
