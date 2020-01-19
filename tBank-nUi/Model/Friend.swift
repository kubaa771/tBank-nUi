//
//  Friend.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 19/01/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import Foundation

class Friend {
    var bankAccountNumber: String = ""
    var name: String = ""
    
    init(bankAccountNumber: String, name: String) {
        self.bankAccountNumber = bankAccountNumber
        self.name = name
    }
}
