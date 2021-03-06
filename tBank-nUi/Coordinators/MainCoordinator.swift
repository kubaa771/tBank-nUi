//
//  MainCoordinator.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 04/01/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.isTranslucent = true
    }
    
    func start() {
        let vc = LoginPageViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
        //navigationController.present(vc, animated: false, completion: nil)
    }
    
    func successfulLogin() {
        //rozbic na kilka koordynatorow
        let vc = MainViewController.instantiate()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
        //navigationController.present(vc, animated: true, completion: nil)
        //navigationController.pushViewController(vc, animated: true)
        
        
    }
    
    func makeNewTransfer(currentUser: User) {
        /*let child = NewTransferCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(with: userData)*/
        let vc = NewTransferViewController.instantiate()
        vc.coordinator = self
        vc.user = currentUser
        navigationController.pushViewController(vc, animated: true)
    }
    
    func makeNewTransferFromFriendsView(currentUser: User, tappedFriend: Friend) {
        let vc = NewTransferViewController.instantiate()
        vc.coordinator = self
        vc.user = currentUser
        vc.friend = tappedFriend
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openFriendsList(currentUser: User) {
        let vc = FriendsListViewController.instantiate()
        vc.coordinator = self
        vc.currentUser = currentUser
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openProfileVC(currentUser: User) {
        let vc = ProfileViewController.instantiate()
        vc.coordinator = self
        vc.currentUser = currentUser
        navigationController.pushViewController(vc, animated: true)
    }
    
    func scanQRCode(currentUser: User){
        let vc = QRCodeScannerViewController.instantiate()
        vc.coordinator = self
        vc.currentUser = currentUser
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func didFinishTransfer() {
        
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    
}
