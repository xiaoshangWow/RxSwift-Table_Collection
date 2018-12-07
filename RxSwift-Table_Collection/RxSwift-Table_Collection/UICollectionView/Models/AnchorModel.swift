//
//  AnchorModel.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import ObjectMapper
import RxDataSources

class AnchorModel: Mappable {
    
    var name = ""   // 名字
    var pic51 = ""  // 头像
    var pic74 = ""  // 大图
    var live = 0
    var push = 0
    var focus = 0   // 关注量
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name  <- map["name"]
        pic51 <- map["pic51"]
        pic74 <- map["pic74"]
        live  <- map["live"]
        push  <- map["push"]
        focus <- map["focus"]
    }
}

struct AnchorSection {
    // itmes就是rows
    var items: [Item]
    
    // 你也可以这里加你需要的东西，比如 headerView 的 title
}

extension AnchorSection: SectionModelType {
    // 重定义 Item 的类型为
    typealias Item = AnchorModel
    
    init(original: AnchorSection, items: [AnchorSection.Item]) {
        self = original
        self.items = items
    }
}
