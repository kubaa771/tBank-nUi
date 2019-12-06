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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackgroundImage(imageName: "redbackground.png")
        updateView()
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
            var bankAccountNumber = user.bankAccountNumber!
            bankAccountNumber.insert("-", at: bankAccountNumber.index(bankAccountNumber.startIndex, offsetBy: 4))
            self.userAccountNumberLabel.text = bankAccountNumber
        }

    }


}

