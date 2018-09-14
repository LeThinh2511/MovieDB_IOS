//
//  SignInViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/10/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FirebaseDatabase

class LogInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var googleButton: GIDSignInButton!

    private var presenter: LogInViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter = LogInViewPresenter(view: self)
    }

    private func setUp() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        self.showHUD(progressLabel: Message.loading)
        GIDSignIn.sharedInstance().signIn()
        googleButton.style = .wide
    }
}

extension LogInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            self.dismissHUD(isAnimated: true)
            self.showMessage(title: GeneralName.appName, message: error.localizedDescription)
            return
        }
        self.presenter.createDataReference(user: user)
    }
}

extension LogInViewController: LogInView {
    func createDataReferenceFailure(message: String) {
        self.dismissHUD(isAnimated: true)
        self.showMessage(title: GeneralName.appName, message: message)
    }

    func createDataReferenceSuccess() {
        self.dismissHUD(isAnimated: true)
        self.performSegue(withIdentifier: "LogInSuccess", sender: nil)
    }
}
