//
//  HeroModel.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit

class HeroModel: NSObject {
    
    var name: String = ""
    var icon: String = ""
    var intro: String = ""
    
    init(dict: [String : Any]) {
        super.init()
        
        name = dict["name"] as? String ?? ""
        icon = dict["icon"] as? String ?? ""
        intro = dict["intro"] as? String ?? ""
    }
}
