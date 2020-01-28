//
//  LoginPageViewController.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 16/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

struct KeychainConfiguration {
  static let serviceName = "tBank-nUi"
  static let accessGroup: String? = nil
}

class LoginPageViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    let touchMe = BiometricIdAuth()
    
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var touchIdButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
            
        // 2
        if hasLogin {
          loginButton.setTitle("Log In", for: .normal)
          loginButton.tag = loginButtonTag
        } else {
          loginButton.setTitle("Create", for: .normal)
          loginButton.tag = createLoginButtonTag
        }
            
        // 3
        /*if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
          usernameTextField.text = storedUsername
        }*/
        
        touchIdButton.isHidden = !touchMe.canEvaluatePolicy()
        
        switch touchMe.biometricType() {
        case .faceID:
          touchIdButton.setImage(UIImage(named: "FaceIcon"),  for: .normal)
        default:
          touchIdButton.setImage(UIImage(named: "Touch-icon-lg"),  for: .normal)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
  
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        /*if checkLogin(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") {
            performSegue(withIdentifier: "dismissLogin", sender: self)
        }*/
        // Check that text has been entered into both the username and password fields.
        guard let newAccountName = usernameTextField.text,
          let newPassword = passwordTextField.text,
          !newAccountName.isEmpty,
          !newPassword.isEmpty else {
            showLoginFailedAlert()
            return
        }
          
        // 2
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        FirebaseBackend.shared.checkUserLogin(givenEmail: newAccountName, givenPassword: newPassword) { (matched) in
            if matched {
                if sender.tag == self.createLoginButtonTag {

                    let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
                    if !hasLoginKey && self.usernameTextField.hasText {
                        UserDefaults.standard.setValue(self.usernameTextField.text, forKey: "username")
                    }
                    
                    do {
                        // This is a new account, create a new keychain item with the account name.
                        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                            account: newAccountName,
                                                            accessGroup: KeychainConfiguration.accessGroup)
                      
                        // Save the password for the new item.
                        try passwordItem.savePassword(newPassword)
                    } catch {
                        fatalError("Error updating keychain - \(error)")
                    }
                    
                    UserDefaults.standard.set(true, forKey: "hasLoginKey")
                    self.loginButton.tag = self.loginButtonTag
                    //self.performSegue(withIdentifier: "dismissLogin", sender: self)
                    self.coordinator?.successfulLogin()
                    
                } else if sender.tag == self.loginButtonTag {
                    self.coordinator?.successfulLogin()
                    //self.performSegue(withIdentifier: "dismissLogin", sender: self)
                    /*if self.checkLogin(username: newAccountName, password: newPassword) {
                        self.performSegue(withIdentifier: "dismissLogin", sender: self)
                    } else {
                        self.showLoginFailedAlert()
                    }*/
                }
            } else {
                print("You've given wrong account data, or this account doesn't exist!")
                self.showLoginFailedAlert()
            }
        }
          
        // 3
        
    }
    
    
    
    @IBAction func touchIdLoginAction(_ sender: UIButton) {
        touchMe.authenticateUser() { [weak self] in
            self?.autoInsertLoginData()
            //self?.performSegue(withIdentifier: "dismissLogin", sender: self)
        }
    }
    
    
    func checkLogin(username: String, password: String) -> Bool {
        //return email == self.username && password == self.password
        
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
          }
            
          do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
          } catch {
            fatalError("Error reading password from keychain - \(error)")
          }
        
    }
    
    func autoInsertLoginData() {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String else {
            return
        }
          
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                  account: username,
                                                  accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            usernameTextField.text = username
            passwordTextField.text = keychainPassword
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        
    }
    
    func createMainVieControllerSegue() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.show(vc, sender: nil)
    }
    
    private func showLoginFailedAlert() {
      let alertView = UIAlertController(title: "Login Problem",
                                        message: "Wrong username or password.",
                                        preferredStyle:. alert)
      let okAction = UIAlertAction(title: "OK!", style: .default)
      alertView.addAction(okAction)
      present(alertView, animated: true)
    }
    

}

extension LoginPageViewController {
    func updateView() {
        updateBackgroundImage(imageName: "loginchoppedbg")
        loginButton.backgroundColor = UIColor(red: 0.062, green: 0.059, blue: 0.058, alpha: 1)
    }
}
