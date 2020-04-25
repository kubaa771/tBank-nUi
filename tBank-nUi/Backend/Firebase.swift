//
//  FirebaseDatabase.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 16/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import Firebase

class FirebaseBackend {
    static let shared = FirebaseBackend()
    var lastSnapshotTimestamp: NSNumber!
    
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
        
        let name: String = "Someone"
        let surname: String = "Else"
        let email: String = user.email!
        let id = user.uid
        let money: Float = 210
        let bankAccountNumber: String = "8095142326253554"
               
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
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
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
        let group = DispatchGroup()
        userTransactionRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                group.enter()
                guard let childSnapshot = child as? DataSnapshot else {return}
                let transactionId = childSnapshot.key
                let ref = Database.database().reference().child("transactions").child(transactionId)
                
                ref.observeSingleEvent(of: .value) { (transactionSnapshot) in
                    guard let dictionary = transactionSnapshot.value as? [String:  Any] else { return }
                    let transaction = Transaction()
                    transaction.setValuesForKeys(dictionary)
                    transactions.append(transaction)
                    group.leave()
                    print("added smth")
                }
            }
            group.notify(queue: .main) {
                completion(transactions)
            }
            
            
        }
        
    }
    
    func paginateData(emptyTransactionArray: Bool, userId: String, completion: @escaping (Array<Transaction>) -> Void) {
        var userTransactionRef: DatabaseQuery!
        var last: Bool = false
        
        if emptyTransactionArray {
            userTransactionRef = Database.database().reference().child("user-transactions").child(userId).queryOrderedByValue().queryLimited(toLast: 6)
            print("last 6 transacitons loaded")
        } else {
            userTransactionRef = Database.database().reference().child("user-transactions").child(userId).queryOrderedByValue().queryEnding(atValue: lastSnapshotTimestamp).queryLimited(toLast: 3)
            print("next 3 transactions loaded")
        }
        
        var transactions: [Transaction] = []
        let group = DispatchGroup()
        userTransactionRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.isEmpty {
                return
            }
            for child in snapshot.children {
                group.enter()
                guard let childSnapshot = child as? DataSnapshot else {return}
                let transactionId = childSnapshot.key
                print(childSnapshot)
                print(snapshot.children.allObjects.first as! DataSnapshot)
                let lastSnapshot = snapshot.children.allObjects.first as? DataSnapshot
                if childSnapshot.key == lastSnapshot?.key {
                    last = true
                }
                
                //ten ref tez zqueryowac zeby byl ordered i limited
                let ref = Database.database().reference().child("transactions").child(transactionId)
                
                ref.observeSingleEvent(of: .value) { (transactionSnapshot) in
                    guard let dictionary = transactionSnapshot.value as? [String:  Any] else { return }
                    let transaction = Transaction()
                    transaction.setValuesForKeys(dictionary)
                    transactions.append(transaction)
                    if last == true {
                        self.lastSnapshotTimestamp = transaction.transactionDate
                        print("TIMESTAMP: \(self.lastSnapshotTimestamp)")
                        last = false
                    }
                    group.leave()
                    print("added smth")
                }
            }
            group.notify(queue: .main) {
                transactions.sort { (t1, t2) -> Bool in
                    let transactionDate1 = TimeInterval(Double(truncating: t1.transactionDate!))//NSDate(timeIntervalSince1970: TimeInterval(Double(t1.transactionDate!)))
                    let transactionDate2 = TimeInterval(Double(truncating: t2.transactionDate!))//NSDate(timeIntervalSince1970: TimeInterval(Double(t2.transactionDate!)))
                    return transactionDate1 > transactionDate2
                }
                completion(transactions)
            }
            
            
        }
        
        
    }
    
    func getLatestTransaction(userId: String, completion: @escaping (Transaction) -> Void) {
        let userTransactionRef = Database.database().reference().child("user-transactions").child(userId).queryOrderedByValue().queryLimited(toLast: 1)
        
        userTransactionRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.isEmpty {
                return
            }
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else {return}
                let transactionId = childSnapshot.key
                print(childSnapshot)

                let ref = Database.database().reference().child("transactions").child(transactionId)
                ref.observeSingleEvent(of: .value) { (transactionSnapshot) in
                    guard let dictionary = transactionSnapshot.value as? [String:  Any] else { return }
                    let transaction = Transaction()
                    transaction.setValuesForKeys(dictionary)
                    completion(transaction)
                }
            }
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
            
            guard let senderId = sender.id else { return }
            let senderTransactionRef = Database.database().reference().child("user-transactions").child(senderId).child(transactionId)
            senderTransactionRef.setValue(values["transactionDate"]) //ustawic timestamp transakcji
            
            self.getUserBy(bankAccountNumber: receiverBankAccountNumber) { (receiver) in
                guard let receiverId = receiver.id else { return }
                let receiverTransactionRef = Database.database().reference().child("user-transactions").child(receiverId).child(transactionId)
                receiverTransactionRef.setValue(values["transactionDate"]) //ustawic timestamp transakcji
            }
            
            NotificationCenter.default.post(name: NotificationNames.refreshTransactionsData.notification, object: nil)
            
              
        }
    }
    
    func updateMoneyFor(senderBankAccountNumber: String, receiverBankAccountNumber: String, amount: Float) {
        getUserBy(bankAccountNumber: senderBankAccountNumber) { (sender) in
            let ref = Database.database().reference().child("users").child(sender.id!)
            let senderMoneyBeforeTransaction = sender.money as! Float
            let senderMoneyAfterTransaction = senderMoneyBeforeTransaction - amount
            //ref.setValue(senderMoneyAfterTransaction, forKey: "money")
            //ref.setValuesForKeys(["money": senderMoneyAfterTransaction])
            ref.updateChildValues(["money": senderMoneyAfterTransaction])
            //ref.setValue(senderMoneyAfterTransaction)
        }
        
        getUserBy(bankAccountNumber: receiverBankAccountNumber) { (receiver) in
            let ref = Database.database().reference().child("users").child(receiver.id!)
            let receiverMoneyBeforeTransaction = receiver.money as! Float
            let receiverMoneyAfterTransaction = receiverMoneyBeforeTransaction + amount
            //ref.setValuesForKeys(["money": receiverMoneyAfterTransaction])
            //ref.setValue(receiverMoneyAfterTransaction, forKey: "money")
            ref.updateChildValues(["money": receiverMoneyAfterTransaction])
            
        }
    }
    
    func addFriendForCurrentUserId(currentUser: User, friendBankAccount: String, friendName: String) {
        let ref = Database.database().reference().child("user-friends").child(currentUser.id!)
        ref.child(friendBankAccount).setValue(friendName)
    }
    
    func getFriends(for currentUser: User, completion: @escaping ([Friend]) -> Void) {
        let ref = Database.database().reference().child("user-friends").child(currentUser.id!)
        var friends: [Friend] = []
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for friend in snapshot.children {
                guard let friendSnapshot = friend as? DataSnapshot else { return }
                let bankAccountNumber = friendSnapshot.key
                let name = friendSnapshot.value as! String
                let friend = Friend(bankAccountNumber: bankAccountNumber, name: name)
                
                friends.append(friend)
            }
            completion(friends)
        }
    }
    
}
