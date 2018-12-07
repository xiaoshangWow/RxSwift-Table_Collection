//
//  WTLabelViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/6.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WTLabelViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        timer.map { String(format: "%0.2d:%0.2d:%0.1d", arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10]) }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
}

