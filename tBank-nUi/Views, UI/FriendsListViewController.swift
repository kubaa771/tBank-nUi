//
//  FriendsListViewController.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 15/01/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    weak var coordinator: MainCoordinator?
    
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    

}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryContactCell", for: indexPath) as! HistoryContactCell
        cell.modelForFriendView = currentUser
        return cell
    }
    
    
}
