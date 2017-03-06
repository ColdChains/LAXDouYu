//
//  RoomCollectionViewHeader.swift
//  LAXDouyu
//
//  Created by 冰凉的枷锁 on 2016/10/11.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import UIKit

class RoomCollectionViewHeader: UICollectionReusableView {
    
    var callback: ((Void) -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func moreAction(_ sender: UIButton) {
        print(1234)
        
        if let call = callback {
            call()
        }
        
    }
    
}
