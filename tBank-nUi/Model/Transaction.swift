//
//  Transaction.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 07/12/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation

class Transaction: NSObject {
    @objc var amount: NSNumber?
    @objc var senderBankAccountNumber: String?
    @objc var receiverBankAccountNumber: String?
    @objc var transactionDate: NSNumber?
    @objc var transactionTitle: String?
    @objc var receiverName: String?
    @objc var senderName: String?
    
    func getUserByBankAccountNumber() {
        // jezeli toUser bedzie potrzebny gdzies indziej niz w wygladzie celki
    }
}
