//
//  NotificationNames.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 07/01/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import Foundation

enum NotificationNames: String {
    
    case refreshTransactionsData = "refreshTransactionsData"
    
    var notification: Notification.Name {
        return Notification.Name(self.rawValue)
    }
}
