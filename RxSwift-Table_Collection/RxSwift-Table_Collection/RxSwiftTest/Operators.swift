//
//  Operators.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/7.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Two way binding operator between control property and variable, that's all it takes {

infix operator <->: DefaultPrecedence

func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument
    
    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }
    
    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }
    
    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
    let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
        return text
    }
    
    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

func <-> <Base>(textInput: TextInput<Base>, variable: Variable<String>) -> Disposable {
    let bindToUIDisposable = variable.asObservable().bind(to: textInput.text)
    let bindToVariable = textInput.text.subscribe(onNext: { [weak base = textInput.base] n in
        guard let base = base else {
            return
        }
        
        let nonMarkedTextValue = nonMarkedText(base)
        
        if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
            variable.value = nonMarkedTextValue
        }
        }, onCompleted: {
            bindToUIDisposable.dispose()
    })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
    if T.self == String.self {
        #if DEBUG
        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to variable.\n" +
            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
            "REMEDY: Just use `textField <-> variable` instead of `textField.rx.text <-> variable`.\n" +
            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
        )
        #endif
    }
    
    let bindToUIDisposeble = variable.asObservable().bind(to: property)
    let bindToVariable = property.subscribe(onNext: { n in
        variable.value = n
    }, onCompleted: {
        bindToUIDisposeble.dispose()
    })
    
    return Disposables.create(bindToUIDisposeble, bindToVariable)
}
