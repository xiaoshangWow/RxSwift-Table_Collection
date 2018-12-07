//
//  RxCollectionViewCell.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import Kingfisher

class RxCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var focusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var anchorModel: AnchorModel? {
        didSet {
            guard let model = anchorModel else {
                return
            }
            
            nameLabel.text = model.name
            focusLabel.text = "\(model.focus)人关注"
            headImage.kf.setImage(with: URL(string: model.pic51))
        }
    }
}
