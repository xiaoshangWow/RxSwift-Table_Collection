//
//  ResultProtocol.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//
// 用于判断和处理字体的文字颜色和状态

import Foundation
import RxSwift
import RxCocoa

enum Result {
    case success(message: String)
    case failture(message: String)
}

extension Result {
    // 字体颜色
    var textColor: UIColor {
        switch self {
        case .success:
            return UIColor.black
        default:
            return UIColor.red
        }
    }
    
    // 描述字体
    var description: String {
        switch self {
        case let .success(message):
            return message
        case let .failture(message):
            return message
        }
    }
    
    // 返回是否成功
    var isValid: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
}

// MARK: 创建UILable的监听者,改变字体和颜色
extension Reactive where Base: UILabel {
    var validationResult: Binder<Result> {
        return Binder(self.base, binding: { (lable, result) in
            lable.textColor = result.textColor
            lable.text = result.description
        })
    }
}

// MARK: 创建UITextField的监听者,是否可编辑
extension Reactive where Base: UITextField {
    var enableResult: Binder<Result> {
        return Binder(self.base, binding: { (textFiled, result) in
            textFiled.isEnabled = result.isValid
        })
    }
}

// MARK: 创建UIButton的监听者,是否可编辑下的背景颜色
extension Reactive where Base: UIButton {
    var backColorResult: Binder<Bool> {
        return Binder(self.base, binding: { (button, result) in
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = result ? UIColor.red : UIColor.lightGray
        })
    }
}
