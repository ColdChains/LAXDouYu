//
//  RoomCollectionViewCell.swift
//  LAXDouyu
//
//  Created by 冰凉的枷锁 on 2016/10/11.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import UIKit

class RoomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roomViewUp: UIView!
    
    @IBOutlet weak var roomImageView: UIImageView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var onLineLabel: UILabel!
    
    @IBOutlet weak var roomTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        roomViewUp.layer.cornerRadius = 8
//        roomViewUp.layer.masksToBounds = true
    }

}
