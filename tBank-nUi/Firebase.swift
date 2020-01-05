//
//  FirebaseDatabase.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 16/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FirebaseBackend {
    static let shared = FirebaseBackend()
    
    func checkUserLogin(givenEmail: String, givenPassword: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: givenEmail, password: givenPassword) { (user, error) in
            if user != nil {
                completion(true)
            } else {
                completion(false)
            }
            if let errorString = error?.localizedDescription {
                completion(false)
                print(errorString)
            }
            
            
        }
    
    }
    
    
    func getUserData(completion: @escaping (User) -> Void ) {
        guard let user = Auth.auth().currentUser else { return }
        
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let userData = User()
            userData.setValuesForKeys(dictionary)
            completion(userData)
            
        }
    }
    
    func addExampleUserData() {
        guard let user = Auth.auth().currentUser else { return }
               
        let ref = Database.database().reference().child("users")
        
        let name: String = "John"
        let surname: String = "Steward"
        let email: String = user.email!
        let id = user.uid
        let money: Float = 543
        let bankAccountNumber: String = "6542362177852345"
               
        let values = ["name" : name, "surname" : surname, "email" : email, "id" : id, "money" : money, "bankAccountNumber" : bankAccountNumber] as [String : Any]
        ref.child(id).updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
        }
           
    }
    
    func getUserBy(bankAccountNumber: String, completion: @escaping (User) -> Void ){
        let ref = Database.database().reference().child("users")
        
        ref.observe(.value) { (snapshot) in
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else { return }
                guard let values = childSnapshot.value as? [String : Any] else { return }
                let extractedBankAccountNumber = values["bankAccountNumber"] as! String
                if extractedBankAccountNumber == bankAccountNumber {
                    let userData = User()
                    userData.setValuesForKeys(values)
                    completion(userData)
                }
            }
        }
    }
    
    func getTransactions(for userId: String, completion: @escaping (Array<Transaction>) -> Void) {
        let userTransactionRef = Database.database().reference().child("user-transactions").child(userId)
        
        var transactions: [Transaction] = []
        
        userTransactionRef.observe(.value) { (snapshot) in
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else {return}
                let transactionId = childSnapshot.key
                let ref = Database.database().reference().child("transactions").child(transactionId)
                
                ref.observe(.value) { (transactionSnapshot) in
                    guard let dictionary = transactionSnapshot.value as? [String:  Any] else { return }
                    let transaction = Transaction()
                    transaction.setValuesForKeys(dictionary)
                    transactions.append(transaction)
                    print("1")
                }
            }
            print("2")
            
        }
        
    }
    
    func manageNewMoneyTransfer(values: [String: Any], sender: User) {
        let ref = Database.database().reference().child("transactions").childByAutoId()
        ref.updateChildValues(values) { (err, dbref) in
            if err != nil {
                print(err?.localizedDescription as Any)
                return
            }
            
            guard let transactionId = ref.key else { return }
            
            guard let receiverBankAccountNumber = values["receiverBankAccountNumber"] as? String else { return }
            
            self.getUserBy(bankAccountNumber: receiverBankAccountNumber) { (receiver) in
                guard let senderId = sender.id else { return }
                guard let receiverId = receiver.id else { return }
                
                let senderTransactionRef = Database.database().reference().child("user-transactions").child(senderId).child(transactionId)
                senderTransactionRef.setValue(1)
                
                let receiverTransactionRef = Database.database().reference().child("user-transactions").child(receiverId).child(transactionId)
                receiverTransactionRef.setValue(1)
            }
            
            
            
        }
    }
    
}
