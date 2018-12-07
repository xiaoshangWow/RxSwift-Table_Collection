//
//  WTGestureViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/6.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WTGestureViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = .up
        self.view.addGestureRecognizer(swipeGesture)
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        
        swipeGesture.rx.event.subscribe(onNext: { [weak self] recognizer in
            let point = recognizer.location(in: recognizer.view)
            self?.showMessage(text: "点击了", message: "x:\(point.x) y:\(point.y)")
        }).disposed(by: disposeBag)
        
        tapGesture.rx.event.subscribe(onNext: { [weak self] recognizer in
            let point = recognizer.location(in: recognizer.view)
            self?.showMessage(text: "点击了",message: "x:\(point.x) y: \(point.y)")
        }).disposed(by: disposeBag)
    }
    
    func showMessage(text: String, message: String) {
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "哦", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
