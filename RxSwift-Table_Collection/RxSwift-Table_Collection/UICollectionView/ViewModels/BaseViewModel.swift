//
//  BaseViewModel.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// 刷新的状态
enum JunRefreshStatus {
    case none
    case begingHeaderRefresh
    case endHeaderRefresh
    case begingFooterRefresh
    case endFooterRefresh
    case noMoreData
}

protocol JunViewModelType {
    // associatedtype: 关联类型为协议的某个类型提供一个占位名 (或者说别名), 其代表的实际类型在协议被采纳时才会指定
    associatedtype Input
    associatedtype Output
    
    // 我们通过 transform 方法将input携带的数据进行处理, 生成了一个output
    func transform(input: Input) -> Output
}

class BaseViewModel: NSObject {
    // 记录当前的索引值
    var index: Int = 1
    
    struct JunInput {
        // 网络请求类型
        let category: JunNetworkTool
        
        init(category: JunNetworkTool) {
            self.category = category
        }
    }
    
    struct JunOutput {
        // tableView的sections数据
        let sections: Driver<[AnchorSection]>
        
        // 外界通过该属性告诉viewModel加载数据(传入的值是为了标志是否重新加载)
        let requestCommod = PublishSubject<Bool>()
        
        // 告诉外界的tableView当前的刷新状态
        let refreshStatus = Variable<JunRefreshStatus>(.none)
        
        // 初始化时, section的数据
        init(sections: Driver<[AnchorSection]>) {
            self.sections = sections
        }
    }
}
