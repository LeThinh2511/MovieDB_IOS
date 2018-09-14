//
//  FirebaseRepository.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/14/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import GoogleSignIn

class FirebaseRepository {
    static let shared = FirebaseRepository()

    private init() {
    }

    func authenticateUser(user: GIDGoogleUser) -> FirebaseAuthenResult {
        guard let authentication = user.authentication else {
            return .failure(message: Message.logInFailure)
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        var isSuccess = true
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                isSuccess = false
                return
            }
            guard let result = authResult, let userInfo = result.additionalUserInfo else {
                isSuccess = false
                return
            }
            FirDataReference.ref = Database.database().reference()
                .child(FirDataReference.usersPath).child(result.user.uid)
            if userInfo.isNewUser {
                let userName = result.user.displayName ?? ""
                let userEmail = result.user.email ?? ""
                FirDataReference.ref.updateChildValues([FirDataReference.userName: userName,
                                                        FirDataReference.userEmail: userEmail])
            }
        }
        if isSuccess {
            return .success
        }
        return .failure(message: Message.logInFailure)
    }

    func addChildAddedObserver(success: @escaping (Movie) -> Void, failure: @escaping (String) -> Void) {
        FirDataReference.favoriteMovieRef.observe(.childAdded, with: { (snapshot) in
            let child = snapshot.value as? [String: Any] ?? [:]
            if let movie = Movie(JSON: child) {
                success(movie)
            }
        }, withCancel: { (error) in
            failure(error.localizedDescription)
        })
    }

    func addChildRemovedOvserver(success: @escaping (Movie) -> Void, failure: @escaping (String) -> Void) {
        FirDataReference.favoriteMovieRef.observe(.childRemoved, with: { (snapshot) in
            let child = snapshot.value as? [String: Any] ?? [:]
            if let movie = Movie(JSON: child) {
                success(movie)
            }
        }, withCancel: { (error) in
            failure(error.localizedDescription)
        })
    }
}

enum FirebaseAuthenResult {
    case success
    case failure(message: String)
}
