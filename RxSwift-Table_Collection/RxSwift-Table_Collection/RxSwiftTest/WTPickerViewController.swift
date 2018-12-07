//
//  WTPickerViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/7.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WTPickerViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    let disposeBag = DisposeBag()
    
    private let adapter1 = RxPickerViewStringAdapter<[String]>(
        components: [],
        numberOfComponents: {_, _, _ in 1 },
        numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count },
        titleForRow: { (_, _, items, row, _) -> String? in
            return items[row] }
    )
    
    private let adapter2 = RxPickerViewStringAdapter<[[String]]>(
        components: [],
        numberOfComponents: { dataSource, pickerView, components in components.count },
        numberOfRowsInComponent: { (_, _, components, component) -> Int in return components[component].count },
        titleForRow: { (_, _, components, row, component) -> String? in return components[component][row]}
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just(["1", "2", "3", "4"]).bind(to: pickerView.rx.items(adapter: adapter1)).disposed(by: disposeBag)
        
        pickerView.rx.itemSelected.subscribe(onNext: { (row, component) in
            print("component: \(component), row: \(row)")
        }).disposed(by: disposeBag)
        
        Observable.just([["1", "2"], ["A", "B", "C", "D", "E"]]).bind(to: pickerView2.rx.items(adapter: adapter2)).disposed(by: disposeBag)
        
        pickerView2.rx.itemSelected.subscribe(onNext: { (row, component) in
            print("component: \(component), row: \(row)")
        }).disposed(by: disposeBag)
    }
}
