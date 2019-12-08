//
//  User.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 14/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation

class User: NSObject {
    @objc var name: String?
    @objc var surname: String?
    @objc var email: String?
    @objc var id: String?
    @objc var money: NSNumber?
    @objc var bankAccountNumber: String?
    
    func translateBankAccountNumber() {
        //zmienic to
        bankAccountNumber!.insert("-", at: bankAccountNumber!.index(bankAccountNumber!.startIndex, offsetBy: 4))
        bankAccountNumber!.insert("-", at: bankAccountNumber!.index(bankAccountNumber!.startIndex, offsetBy: 9))
        bankAccountNumber!.insert("-", at: bankAccountNumber!.index(bankAccountNumber!.startIndex, offsetBy: 14))
    }
    
}
