//
//  Transaction.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 07/12/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation

class Transaction {
    var amount: Int?
    var fromUser: User?
    var toUserBankAccountNumber: String?
    var transactionDate: NSDate?
    var transactionTitle: String?
    
    func getUserByBankAccountNumber() {
        //
    }
}
