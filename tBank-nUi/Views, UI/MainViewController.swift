//
//  ViewController.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 13/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, Storyboarded {
    
    // MARK: Variables, ViewController functions
    
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var moneyBackgroundImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAccountNumberLabel: UILabel!
    @IBOutlet weak var userMoneyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonView: FloatingButtonView!
    
    
    var user: User! = nil
    var transactions: [Transaction] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationBar()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        buttonView.layer.cornerRadius = 30
        buttonView.tappedClosure = newTransferButtonSegueClosure
        NotificationCenter.default.addObserver(self, selector: #selector(getTransactionsData), name: NotificationNames.refreshTransactionsData.notification, object: nil)
        //updateBackgroundImage(imageName: "redbackground.png")
        //updateView()
        updateUserData()
        //FirebaseBackend.shared.addExampleUserData()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        longPressRecognizer.minimumPressDuration = 1.5
        view.addGestureRecognizer(longPressRecognizer)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonView.buttonView.bounds.height + 40, right: 0)
    }
    
    
    // MARK: Update UI
    
    func updateView() {
        moneyBackgroundImage.layer.masksToBounds = false
        moneyBackgroundImage.layer.cornerRadius = 120
        moneyBackgroundImage.clipsToBounds = true
        moneyBackgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        //moneyBackgroundImage.image = UIImage(contentsOfFile: "blackbg.jpg")
    }
    
    func updateNavigationBar() {
        let walletLabel = UILabel()
        walletLabel.text = "Wallet"
        walletLabel.font = UIFont.boldSystemFont(ofSize: 40.0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: walletLabel)
        
        let profileImage = UIImage(systemName: "person")
        let profileBarButton = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfileButtonAction))
        
        let friendsImage = UIImage(systemName: "person.2")
        let friendsBarButton = UIBarButtonItem(image: friendsImage, style: .plain, target: self, action: #selector(didTapFriendsButtonAction))
        navigationItem.rightBarButtonItems = [profileBarButton, friendsBarButton]
    }
    
    func createBubbleView(rect: CGPoint) {
        let bubbleView = CopiedBubbleView()
        bubbleView.frame = CGRect(x: rect.x-50, y: rect.y-40, width: 100, height: 30)
        view.addSubview(bubbleView)
        UIView.animate(withDuration: 1.5, animations: {bubbleView.alpha = 0.0}) { (bool) in
            bubbleView.removeFromSuperview()
        }
    }
    
    // MARK: Update backend
    
    func updateUserData() {
        FirebaseBackend.shared.getUserData { (user) in
            let userNameInfo = (user.name ?? "") + " " + (user.surname ?? "")
            self.userNameLabel.text = userNameInfo
            let money = user.money as! Float
            self.userMoneyLabel.text = String(money) + " $"
            var bankAccountNumber = user.bankAccountNumber!
            bankAccountNumber.translateBankAccountNumber()
            self.userAccountNumberLabel.text = bankAccountNumber
            self.user = user
            self.getTransactionsData()
        }  
        

    }
    
    @objc func getTransactionsData() {
        FirebaseBackend.shared.getTransactions(for: self.user.id!) { (transactions) in
            self.transactions = transactions
            self.transactions.sort { (t1, t2) -> Bool in
                let transactionDate1 = TimeInterval(Double(truncating: t1.transactionDate!))//NSDate(timeIntervalSince1970: TimeInterval(Double(t1.transactionDate!)))
                let transactionDate2 = TimeInterval(Double(truncating: t2.transactionDate!))//NSDate(timeIntervalSince1970: TimeInterval(Double(t2.transactionDate!)))
                return transactionDate1 > transactionDate2
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: Buttons actions
    
    
    @objc func didTapProfileButtonAction(_ sender: AnyObject) {
        print("profile")
    }
    
    @objc func didTapFriendsButtonAction(_ sender: AnyObject) {
        guard let user = user else { return }
        coordinator?.openFriendsList(currentUser: user)
    }
    
    func newTransferButtonSegueClosure() {
        //performSegue(withIdentifier: "newTransferSegue", sender: nil)
        guard let user = user else { return }
        coordinator?.makeNewTransfer(currentUser: user)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "newTransferSegue" {
//            let nvc = segue.destination as! UINavigationController
//            let vc = nvc.topViewController as! NewTransferViewController
//            vc.user = self.user
//        }
//    }
    
    


}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryContactCell", for: indexPath) as! HistoryContactCell
        if user != nil {
            cell.currentUser = user
            cell.model = transactions[indexPath.row]
            
        }
        return cell
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPointForCell = longPressGestureRecognizer.location(in: tableView)
            let touchPointForBubbleView = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPointForCell) {
                let transaction = transactions[indexPath.row]
                if user.bankAccountNumber == transaction.senderBankAccountNumber {
                    UIPasteboard.general.string = transaction.receiverBankAccountNumber
                    createBubbleView(rect: touchPointForBubbleView)
                } else {
                    UIPasteboard.general.string = transaction.senderBankAccountNumber
                    createBubbleView(rect: touchPointForBubbleView)
                }
            }
        }
    }
    
       
}


