//
//  FavoriteViewPresenter.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/27/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import RxSwift

class FavoriteViewPresenter: FavoriteViewPresenterProtocol {

    private weak var view: FavoriteView!
    private let localRepository: LocalRepository!
    private let firebaseRepository = FirebaseRepository.shared

    init(view: FavoriteView, localRepository: LocalRepository) {
        self.view = view
        self.localRepository = localRepository
        localRepository.createTable()
    }

    func loadFavoriteMovies() {
        let selectResult = localRepository.selectAllMovie()
        switch selectResult {
        case .success(let movies):
            self.view.loadFavoriteMovieSuccess(movies: movies)
        case .failure(let error):
            self.view.loadFavoriteMovieFailure(error: error)
        }
    }

    func removeMovie(movie: Movie) {
        let result = localRepository.deleteMovie(movie: movie)
        switch result {
        case .success:
            NotificationCenter.default.post(name: NotificationName.updateFavoriteMovies, object: nil)
            let movieIDString = String(describing: movie.movieID)
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: Constant.updateFavoriteMovie + movieIDString), object: nil)
        case .failure:
            break
        }
    }

    func insertMovie(movie: Movie) {
        let result = localRepository.insertMovie(movie: movie)
        switch result {
        case .success:
            NotificationCenter.default.post(name: NotificationName.updateFavoriteMovies, object: nil)
            let movieIDString = String(describing: movie.movieID)
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: Constant.updateFavoriteMovie + movieIDString), object: nil)
        case .failure:
            break
        }
    }

    func addRemoteObserver() {
        firebaseRepository.addChildAddedObserver(success: { (movie) in
            self.insertMovie(movie: movie)
        }, failure: { (message) in
            self.view.addObserverFailure(message: message)
        })

        firebaseRepository.addChildRemovedOvserver(success: { (movie) in
            self.removeMovie(movie: movie)
        }, failure: { (message) in
            self.view.addObserverFailure(message: message)
        })
    }
}
