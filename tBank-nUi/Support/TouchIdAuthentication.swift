//
//  TouchIdAuthentication.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 16/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
  case none
  case touchID
  case faceID
}

class BiometricIdAuth {
    let context = LAContext()
    var loginReason = "Logging in with Touch ID"
    
    func canEvaluatePolicy() -> Bool {
      return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
      let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
      switch context.biometryType {
      case .none:
        return .none
      case .touchID:
        return .touchID
      case .faceID:
        return .faceID
      }
        
    }
    
    func authenticateUser(completion: @escaping () -> Void) {

      guard canEvaluatePolicy() else {
        return
      }

      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
        localizedReason: loginReason) { (success, evaluateError) in

          if success {
            DispatchQueue.main.async {
              // User authenticated successfully, take appropriate action
              completion()
            }
          } else {
            // TODO: deal with LAError cases
          }
      }
    }
}
