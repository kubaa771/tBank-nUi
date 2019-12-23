//
//  ViewController.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 13/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var moneyBackgroundImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAccountNumberLabel: UILabel!
    @IBOutlet weak var userMoneyLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonView: FloatingButtonView!
    
    
    var user: User! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        buttonView.layer.cornerRadius = 30
        buttonView.tappedClosure = newTransferButtonSegueClosure
        //updateBackgroundImage(imageName: "redbackground.png")
        //updateView()
        updateData()
    }
    
    func updateView() {
        moneyBackgroundImage.layer.masksToBounds = false
        moneyBackgroundImage.layer.cornerRadius = 120
        moneyBackgroundImage.clipsToBounds = true
        moneyBackgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        //moneyBackgroundImage.image = UIImage(contentsOfFile: "blackbg.jpg")
    }
    
    func updateData() {
        FirebaseBackend.shared.getUserData { (user) in
            let userNameInfo = (user.name ?? "") + " " + (user.surname ?? "")
            self.userNameLabel.text = userNameInfo
            let money = user.money as! Float
            self.userMoneyLabel.text = String(money) + " $"
            user.translateBankAccountNumber()
            var bankAccountNumber = user.bankAccountNumber! //!!
            self.userAccountNumberLabel.text = bankAccountNumber
            self.user = user
            self.tableView.reloadData()
        }

    }
    
    func newTransferButtonSegueClosure() {
        performSegue(withIdentifier: "newTransferSegue", sender: nil)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTransferSegue" {
            let vc = segue.destination as! NewTransferViewController
        }
    }*/


}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryContactCell", for: indexPath) as! HistoryContactCell
        if user != nil {
            //cell.model = Transaction(amount: 15, user: user)
        }
        return cell
       }
       
}

