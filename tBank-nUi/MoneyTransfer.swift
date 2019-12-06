//
//  MoneyTransfer.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 14/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation

class MoneyTransfer {
    var id: String
    var title: String
    var money: Float
    var fromId: String
    var toId: String
    
    init(id: String, title: String, money: Float, fromId: String, toId: String) {
        self.id = id
        self.title = title
        self.money = money
        self.fromId = fromId
        self.toId = toId
        
    }
}
