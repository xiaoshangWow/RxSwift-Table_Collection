//
//  WTOtherViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/6.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WTOtherViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var steper: UIStepper!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UISegmentedControl
        segment.rx.selectedSegmentIndex.asObservable()
            .subscribe(onNext:{
                print("选择了第\($0)个")
            }).disposed(by: disposeBag)
        
        // UISwitch,UIActivityIndicatorView
        switch1.rx.isOn
            .bind(to: activityView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        switch1.rx.isOn
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        // UISlider
        slider.rx.value.asObservable().subscribe(onNext: { print("UISlider当前的值: \($0)") }).disposed(by: disposeBag)
        
        // UIStepper
        steper.rx.value.asObservable().subscribe(onNext: { print("当前UIStepper当前的值: \($0)") }).disposed(by: disposeBag)
        
        // UISlider, UIStepper
        steper.rx.value.asObservable().map { Float($0) }.bind(to: slider.rx.value).disposed(by: disposeBag)
        
    }
    
}
