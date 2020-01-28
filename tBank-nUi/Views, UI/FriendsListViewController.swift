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
    var friends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getFriends()
    }
    
    func getFriends() {
        FirebaseBackend.shared.getFriends(for: currentUser) { (friends) in
            self.friends = friends
            self.tableView.reloadData()
        }
    }
    

}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryContactCell", for: indexPath) as! HistoryContactCell
        cell.modelForFriendView = friends[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = currentUser else { return }
        let cellModel = friends[indexPath.row]
        coordinator?.makeNewTransferFromFriendsView(currentUser: user, tappedFriend: cellModel)
    }
    
    
}
