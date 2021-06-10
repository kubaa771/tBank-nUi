//
//  ProfileViewController.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 13/03/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    var currentUser: User! = nil

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQrImage()
        setUpButton()
    }
    
    func loadQrImage() {
        guard let currentUser = currentUser else { return }
        let userNames = (currentUser.name ?? "") + " " + (currentUser.surname ?? "")
        var userBankAccountNumber = currentUser.bankAccountNumber!
        userBankAccountNumber.translateBankAccountNumber()
        
        let stringToEncode = "\(userNames)+\(userBankAccountNumber)"
        
        let qrImage = QRGenerator(stringToEncode: stringToEncode)
        guard let ciImage = qrImage.getQRImage() else { return }
        let uiImage = UIImage(ciImage: ciImage)
        qrImageView.image = uiImage
        
    }
    
    func setUpButton() {
        scanButton.layer.cornerRadius = 20
    }
    
    @IBAction func scanButtonDidTapped(_ sender: UIButton) {
        guard let currentUser = currentUser else { return }
        coordinator?.scanQRCode(currentUser: currentUser)
        
    }

}
