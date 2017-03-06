//
//  DanmuView.swift
//  LAXDouyu
//
//  Created by 冰凉的枷锁 on 2016/10/12.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import UIKit

class DanmuView: UIView {
    
    var messageQueue: [String] = []
    var reuserSet: Set<UILabel> = []
    var labelOnViewSet: Set<UILabel> = []
    var timer: Timer?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        if newSuperview != nil {
            timer = Timer.scheduledTimer(timeInterval: 1 / 60.0, target: self, selector: #selector(self.timerClick(t:)), userInfo: nil, repeats: true)
        }
        else {
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    func timerClick(t: Timer) {
        
        var offSetDic: [CGFloat : CGFloat] = [:]
        
        for label in labelOnViewSet {
            
            var frame = label.frame
            frame.origin.x -= 1
            label.frame = frame
            let newOffSet = label.frame.origin.x + label.frame.size.width
            
            if newOffSet < 0 {
                reuserSet.insert(label)
                label.removeFromSuperview()
            }
            else {
                let line = label.frame.origin.y / label.frame.size.height
                if let old = offSetDic[line] {
                    if old < newOffSet {
                        offSetDic[line] = newOffSet
                    }
                }
            }
        }
        
        for label in reuserSet {
            labelOnViewSet.remove(label)
        }
        
        
        
    }
    
   
    
}
