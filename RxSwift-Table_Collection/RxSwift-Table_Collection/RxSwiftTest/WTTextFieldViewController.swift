//
//  WTTextFieldViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/6.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WTTextFieldViewController: UIViewController {
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField1.rx.text.orEmpty.asObservable()
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        // 文本框的变化序列
        let tfInput = textField1.rx.text.orEmpty.asDriver().throttle(0.5) // 将普通序列转换为 Driver
        
        // 将内容绑定到另一个输入框
        tfInput.drive(textField2.rx.text).disposed(by: disposeBag)
        
        // 将内容绑定到label
        tfInput.map {
            return String(format: "当前输入了%ld个字符", $0.count)
            }.drive(label.rx.text)
            .disposed(by: disposeBag)
        
        // 将内容绑定到button 但输入超过5个才可以点击
        tfInput.map {
            return $0.count > 5
            }.drive(button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 同时监听两个textField
        Observable.combineLatest(textField1.rx.text.orEmpty, textField2.rx.text.orEmpty) { (text1, text2) -> String in
            return String(format: "前1个值: %@, 后1个值: %@", text1, text2)
            }.map { $0 }
            .bind(to: totalLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 监听textField1的回车事件
        textField1.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.textField2.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        // 监听textField2的所有事件
        textField2.rx.controlEvent(.allEditingEvents)
            .subscribe(onNext: {
                print("正在监听所有输入事件")
            }).disposed(by: disposeBag)
    }
    
}
