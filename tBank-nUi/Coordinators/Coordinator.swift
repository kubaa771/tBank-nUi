//
//  Coordinator.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 04/01/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
    
}
