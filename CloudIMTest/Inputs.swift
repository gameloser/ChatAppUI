//
//  Inputs.swift
//  CloudIMTest
//
//  Created by Uchiha Lulu on 16/3/7.
//  Copyright © 2016年 yingge. All rights reserved.
//

import Foundation


struct Inputs: OptionSetType {
    let rawValue: Int
    
    static let username = Inputs(rawValue: 1)       // 001
    static let password = Inputs(rawValue: 1 << 1)  // 010
    static let email = Inputs(rawValue: 1 << 2)     // 100
}

extension Inputs: BooleanType {
    var boolValue: Bool {
        return self.rawValue == 0b111
    }
}

