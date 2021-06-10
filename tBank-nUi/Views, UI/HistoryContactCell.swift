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
            customizeForFriendsView(friend: modelForFriendView)
        }
    }
    
    var currentUser: User!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView() {
        roundView.layer.masksToBounds = false
        roundView.layer.cornerRadius = 30
        roundView.clipsToBounds = true
        roundView.contentMode = UIView.ContentMode.scaleAspectFill
    }
    
    func customize(transaction: Transaction) {
        updateView()
        let amount = transaction.amount as! Float
        if transaction.senderBankAccountNumber == currentUser.bankAccountNumber {
            nameLabel.text = transaction.receiverName
            balanceLabel.text = "-" + String(amount) + "$"
            balanceLabel.textColor = UIColor.red
            initialsLabel.text = transaction.receiverName!.createInitials()
        } else {
            nameLabel.text = transaction.senderName
            balanceLabel.text = "+" + String(amount) + "$"
            balanceLabel.textColor = UIColor.green
            initialsLabel.text = transaction.senderName!.createInitials()
        }
        accountNumberLabel.text = transaction.transactionTitle
    }
    
    func customizeForFriendsView(friend: Friend) {
        updateView()
        nameLabel.text = friend.name
        var mutableBankAccountNumber = friend.bankAccountNumber
        mutableBankAccountNumber.translateBankAccountNumber()
        accountNumberLabel.text = mutableBankAccountNumber
        initialsLabel.text = friend.name.createInitials()
    }

}

extension String {
    func createInitials() -> String {
        let initialsComponents = self.components(separatedBy: " ")
        let firstInitial = initialsComponents.first?.first
        let secondInitial = initialsComponents.last?.first
        return String(firstInitial ?? " ") + String(secondInitial ?? " ")
    }
}
