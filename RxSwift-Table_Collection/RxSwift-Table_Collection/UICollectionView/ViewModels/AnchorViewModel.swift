//
//  AnchorViewModel.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/5.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class AnchorViewModel: BaseViewModel {
    // 存放解析完成的模型数组
    let anchorArr = Variable<[AnchorModel]>([])
}

extension AnchorViewModel : JunViewModelType {
    typealias Input = JunInput
    typealias Output = JunOutput
    
    func transform(input: AnchorViewModel.JunInput) -> AnchorViewModel.JunOutput {
        let sectionArr = anchorArr.asDriver().map { (models) -> [AnchorSection] in
            // 当models的值改变时会调用
            return [AnchorSection(items: models)]
            }.asDriver(onErrorJustReturn: [])
        
        let output = JunOutput(sections: sectionArr)
        
        output.requestCommod.subscribe(onNext: { (isReloadData) in
            self.index = isReloadData ? 1 : self.index + 1
            
            // 开始请求数据
            junNetworkTool.rx.request(JunNetworkTool.getHomeList(page: self.index), callbackQueue: DispatchQueue.main)
                .asObservable()
                .mapObjectArray(AnchorModel.self)
                .subscribe({ (event) in
                    switch event {
                    case let .next(modelArr):
                        self.anchorArr.value = isReloadData ? modelArr : (self.anchorArr.value) + modelArr
                        SVProgressHUD.showSuccess(withStatus: "加载成功")
                    case let .error(error):
                        SVProgressHUD.showError(withStatus: error.localizedDescription)
                    case .completed:
                        output.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                    }
                }).disposed(by: bag)
        }).disposed(by: bag)
        
        return output
    }
}
