//
//  RxTableViewCell.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit

class RxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var heroModel: HeroModel? {
        didSet {
            guard let model = heroModel else {
                return
            }
            
            headerImage.image = UIImage(named: model.icon)
            titleLabel.text = model.name
            detailLabel.text = model.intro
        }
    }
}
