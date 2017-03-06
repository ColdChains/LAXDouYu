//
//  MyTabBarItem.swift
//  LAX_Douyu
//
//  Created by 冰凉的枷锁 on 16/10/8.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import UIKit

class MyTabBarItem: UITabBarItem {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .selected)
//        self.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 22)], for: .normal)
        
    }
    
}
