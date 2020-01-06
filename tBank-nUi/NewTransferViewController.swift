//
//  NewTransferViewController.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 22/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewTransferViewController: UIViewController, UITextFieldDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var receiverNameTextField: UITextField!
    @IBOutlet weak var receiverAccNumberTextField: UITextField!
    @IBOutlet weak var transferTitleTextField: UITextField!
    @IBOutlet weak var transferDateTextField: UITextField!
    @IBOutlet weak var transferAmountTextField: UITextField!
    
    let datePicker = UIDatePicker()
    var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(nil, action: #selector(datePickerChanged), for: .valueChanged)
        transferDateTextField.inputView = datePicker
        receiverAccNumberTextField.delegate = self
        
    }
    
    @objc func datePickerChanged() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        
        transferDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func accountNumberChanged(_ sender: UITextField) {
        /*guard var inputText = sender.text else { return }
        let filteredInputText = inputText.components(separatedBy: "-").joined()
        let symbolsInInputText = inputText.filter({$0.isPunctuation})
        let needOfFourNumbers = inputText.components(separatedBy: "-")//[0].count == 4
        let smth = needOfFourNumbers.compactMap { (string) -> Bool in
            if string.count == 4 {
                return true
            } else {
                return false
            }
        }
        
        print(needOfFourNumbers)
        print(smth)
        
        if filteredInputText.count >= 16 {
            return
        }
        
        if filteredInputText.count % 4 == 0, filteredInputText.count <= 12, symbolsInInputText.count < 3, inputText.last?.isNumber ?? false {
            //inputText.insert("-", at: inputText!.index(inputText!.startIndex, offsetBy: 4))
            receiverAccNumberTextField.text?.append("-")
            
        } else if inputText.last?.isPunctuation ?? false{
            receiverAccNumberTextField.text?.removeLast()
        } else if needOfFourNumbers.last!.count > 4 {
            let stIndex = receiverAccNumberTextField.text?.index(receiverAccNumberTextField.text!.endIndex, offsetBy: -1)
            print(stIndex)
            receiverAccNumberTextField.text?.insert("-", at: stIndex!)
        }*/
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }

        if textField == receiverAccNumberTextField  {
            let textFieldTextCount = textField.text!.count
            if textFieldTextCount < 19 {
                textField.setText(to: currentText.grouping(every: 4, with: "-"), preservingCursor: true)
            } else if textFieldTextCount >= 19 {
                textField.deleteBackward()
                
            }
            

            return false
        }
        return true
    }
    
    
    @IBAction func sendTransactionButtonAction(_ sender: UIButton) {
        guard let user = user else {
            return
        }
        guard let filteredInputText = receiverAccNumberTextField.text?.components(separatedBy: "-").joined() else {
            print("receiver's bank account number cannot be empty")
            return
        }
        print(filteredInputText.count)
        if receiverNameTextField.text != nil, transferAmountTextField.text != nil, filteredInputText.count == 16 {
            if let amount = Float(transferAmountTextField.text!) {
                print(amount)
                let senderBankAccountNumber = user.bankAccountNumber?.components(separatedBy: "-").joined()
                //w transaction date ustawic date z DatePicker() - wykonywany przelew kiedy ustawiona
                let newTransfer: [String: Any] = ["amount" : amount, "senderBankAccountNumber" : senderBankAccountNumber, "receiverBankAccountNumber" : filteredInputText, "transactionDate" : NSNumber(value: NSDate().timeIntervalSince1970), "transactionTitle" : transferTitleTextField.text]
                FirebaseBackend.shared.manageNewMoneyTransfer(values: newTransfer, sender: user)
                FirebaseBackend.shared.updateMoneyFor(senderBankAccountNumber: senderBankAccountNumber!, receiverBankAccountNumber: filteredInputText, amount: amount)
                
            } else {
                print("your price value is not a number")
            }
        }
    }
    
}
