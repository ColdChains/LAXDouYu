//
//  ToolClass.swift
//  LAXDouyu
//
//  Created by 冰凉的枷锁 on 2016/10/12.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import Foundation

func getTime() -> String {
    return String.init(format: "%f", Date.timeIntervalBetween1970AndReferenceDate)
}
