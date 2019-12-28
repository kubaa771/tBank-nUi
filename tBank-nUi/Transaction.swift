//
//  Transaction.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 07/12/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation

class Transaction {
    var amount: NSNumber?
    var senderBankAccountNumber: String?
    var receiverBankAccountNumber: String?
    var transactionDate: NSNumber?
    var transactionTitle: String?
    
    func getUserByBankAccountNumber() {
        // jezeli toUser bedzie potrzebny gdzies indziej niz w wygladzie celki
    }
}
