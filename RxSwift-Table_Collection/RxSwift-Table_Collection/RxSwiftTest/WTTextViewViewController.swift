//
//  WTTextViewViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/6.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WTTextViewViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.rx.didBeginEditing
            .subscribe(onNext: {
                print("开始编辑")
            }).disposed(by: disposeBag)
        
        textView.rx.didChange
            .subscribe(onNext:{
                print("内容变了: \($0)")
            }).disposed(by: disposeBag)
        
        textView.rx.didChangeSelection
            .subscribe(onNext:{
                print("选择内容发生变化: \($0)")
            }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(onNext:{
                print("结束编辑")
            }).disposed(by: disposeBag)
    }
}
