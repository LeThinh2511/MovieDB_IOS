//
//  SettingViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/10/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogOutCell", for: indexPath)
        cell.textLabel?.text = GeneralName.logOut
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            logOut()
        }
    }

    private func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.navigationController?.dismissWithCustomAnimation()
    }
}
