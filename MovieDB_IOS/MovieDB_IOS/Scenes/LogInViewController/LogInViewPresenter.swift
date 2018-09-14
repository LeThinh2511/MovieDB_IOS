//
//  LogInViewPresenter.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/12/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FirebaseDatabase

class LogInViewPresenter: LogInViewPresenterProtocol {

    private weak var view: LogInView!
    let firebaseRepository = FirebaseRepository.shared

    init(view: LogInView) {
        self.view = view
    }

    func createDataReference(user: GIDGoogleUser) {
        let result = firebaseRepository.authenticateUser(user: user)
        switch result {
        case .success:
            self.view.createDataReferenceSuccess()
        case .failure(let message):
            self.view.createDataReferenceFailure(message: message)
        }
    }
}
