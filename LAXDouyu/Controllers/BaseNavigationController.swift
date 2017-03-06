//
//  BaseNavigationController.swift
//  LAXDouyu
//
//  Created by 冰凉的枷锁 on 2016/10/10.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let vc = self.topViewController {
            return vc.supportedInterfaceOrientations
        }
        return .portrait
    }
    
}
