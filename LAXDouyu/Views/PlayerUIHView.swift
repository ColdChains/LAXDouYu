//
//  PlayerUIHView.swift
//  LAXDouyu
//
//  Created by 冰凉的枷锁 on 2016/10/12.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import UIKit

class PlayerUIHView: UIView {
    
    let width = UIScreen.main.bounds.size.height
    let h: CGFloat = 20
    
    var messageQueue: [String] = []
    var labelOnViewSet: Set<UILabel> = []
    var offSetDic: [Int: CGFloat] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0]
    
    var timer1: Timer?
    var timer2: Timer?
    
    func startDanmu() {
        
        print("start")
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.createTimer(t:)), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1 / 50.0, target: self, selector: #selector(self.moveTimer(t:)), userInfo: nil, repeats: true)
        
    }
    
    func stopDanmu() {
        print("stop")
        timer1?.invalidate()
        timer2?.invalidate()
        timer1 = nil
        timer2 = nil
    }
    
    func createTimer(t: Timer) {
        
        for i in 0..<messageQueue.count {
            
            let message = messageQueue[i]
            
            let label = UILabel.init()
            label.text = message
            label.textColor = UIColor.red
            self.addSubview(label)
            
            let w = message.boundingRect(with: CGSize.init(width: 1000, height: 21), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)], context: nil).size.width
            
            //            print(offSetDic.keys)
            for (line, offset) in offSetDic {
//                print(line, offset)
                if offset < self.frame.size.width {
                    
                    let frame = CGRect.init(x: width, y: CGFloat(line) * h + 50, width: w, height: h)
                    label.frame = frame
                    
                    offSetDic[line] = width + w
                    labelOnViewSet.insert(label)
                    
                    print(line, offset, message, label.frame)
                    break
                }
                
            }
            print("--------------")
        }
        messageQueue.removeAll()

    }
    
    func moveTimer(t: Timer) {
//        print(messageQueue)
        
        for label in labelOnViewSet {
            
            var frame = label.frame
            frame.origin.x -= 1
            label.frame = frame

            
            if frame.origin.x + width  < 0 {
                label.removeFromSuperview()
                labelOnViewSet.remove(label)
            }
            
            let line = (frame.origin.y - 50) / h
            let newOffSet = frame.origin.x + frame.size.width
            
            if offSetDic[Int(line)] != nil {
                if offSetDic[Int(line)]! - 1 == newOffSet {
                    offSetDic[Int(line)] = newOffSet
                }
            }
            
        }
    }

}
