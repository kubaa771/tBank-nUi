//
//  HistoryContactCell.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 07/12/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class HistoryContactCell: UITableViewCell {
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var model: Transaction! {
        didSet {
            customize(transaction: model)
        }
    }
    
    var modelForFriendView: Friend! {
        didSet {
            //TODO: Guard statement
            customizeForFriendsView(friend: modelForFriendView)
        }
    }
    
    var currentUser: User!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customize(transaction: Transaction) {
        //TODO: Initials
        let amount = transaction.amount as! Float
        
        if transaction.senderBankAccountNumber == currentUser.bankAccountNumber {
            // odejmuje kase
            nameLabel.text = transaction.receiverName
            balanceLabel.text = "-" + String(amount) + "$"
            balanceLabel.textColor = UIColor.red
        } else {
            // dodaje kase
            nameLabel.text = transaction.senderName
            balanceLabel.text = "+" + String(amount) + "$"
            balanceLabel.textColor = UIColor.green
        }
        
        
        roundView.layer.masksToBounds = false
        roundView.layer.cornerRadius = 30
        roundView.clipsToBounds = true
        roundView.contentMode = UIView.ContentMode.scaleAspectFill
        //var bankAccountNumber = transactionUserBankAccountNumber
        //bankAccountNumber?.translateBankAccountNumber()
        accountNumberLabel.text = transaction.transactionTitle
        
    }
    
    func customizeForFriendsView(friend: Friend) {
        roundView.layer.masksToBounds = false
        roundView.layer.cornerRadius = 30
        roundView.clipsToBounds = true
        roundView.contentMode = UIView.ContentMode.scaleAspectFill
        
        nameLabel.text = friend.name
        var mutableBankAccountNumber = friend.bankAccountNumber
        mutableBankAccountNumber.translateBankAccountNumber()
        accountNumberLabel.text = mutableBankAccountNumber
    }

}
