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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQrImage()
        // Do any additional setup after loading the view.
    }
    
    func loadQrImage() {
        guard let currentUser = currentUser else { return }
        let userNames = (currentUser.name ?? "") + " " + (currentUser.surname ?? "")
        var userBankAccountNumber = currentUser.bankAccountNumber!
        userBankAccountNumber.translateBankAccountNumber()
        
        let stringToEncode = "\(userNames)+\(userBankAccountNumber)"
        
        print(stringToEncode)
        
        var qrImage = QRGenerator(stringToEncode: stringToEncode)
        guard let ciImage = qrImage.getQRImage() else { return }
        let uiImage = UIImage(ciImage: ciImage)
        qrImageView.image = uiImage
        
    }
    
    
    
    
    @IBAction func scanButtonDidTapped(_ sender: UIButton) {
        guard let currentUser = currentUser else { return }
        coordinator?.scanQRCode(currentUser: currentUser)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
