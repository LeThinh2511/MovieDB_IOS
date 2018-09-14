//
//  LogInViewContract.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/12/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import GoogleSignIn

protocol LogInView: class {
    func createDataReferenceFailure(message: String)
    func createDataReferenceSuccess()
}

protocol LogInViewPresenterProtocol: class {
    func createDataReference(user: GIDGoogleUser)
}
