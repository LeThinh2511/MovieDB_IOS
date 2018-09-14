//
//  MoviesBaseViewPresenter.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/6/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import RxSwift

class MoviesBaseViewPresenter: MoviesBaseViewPresenterProtocol {
    private weak var view: MoviesBaseView!
    private var localRepository: LocalRepository!

    init(view: MoviesBaseView, localRepository: LocalRepository) {
        self.view = view
        self.localRepository = localRepository
    }

    func toggleFavoriteMovie(movie: Movie) {
        let isMovieFavorite = localRepository.checkFavoriteMovie(movie: movie)
        if isMovieFavorite {
            removeMovie(movie: movie)
        } else {
            insertMovie(movie: movie)
        }
    }

    private func removeMovie(movie: Movie) {
        let result = localRepository.deleteMovie(movie: movie)
        switch result {
        case .success(let message):
            self.view.removeFavoriteResult(message: message, movie: movie)
            NotificationCenter.default.post(name: NotificationName.updateFavoriteMovies, object: nil)
            guard let movieID = movie.movieID else { return }
            let movieIDString = String(describing: movieID)
            FirDataReference.ref.child(FirDataReference.favoriteMovies)
                .child(movieIDString).removeValue { (error, _) in
                    if let error = error {
                        self.view.removeFavoriteResult(message: error.localizedDescription, movie: movie)
                    }
            }
        case .failure(let error):
            self.view.removeFavoriteResult(message: error.rawValue, movie: movie)
        }
    }

    private func insertMovie(movie: Movie) {
        let result = localRepository.insertMovie(movie: movie)
        switch result {
        case .success(let message):
            self.view.insertFavoriteResult(message: message, movie: movie)
            NotificationCenter.default.post(name: NotificationName.updateFavoriteMovies, object: nil)
            guard let movieID = movie.movieID else { return }
            let movieIDString = String(describing: movieID)
            let movieJSON = movie.toJSON()
            FirDataReference.ref.child(FirDataReference.favoriteMovies)
                .child(movieIDString).updateChildValues(movieJSON) { (error, _) in
                    if let error = error {
                        self.view.insertFavoriteResult(message: error.localizedDescription, movie: movie)
                    }
            }
        case .failure(let error):
            self.view.insertFavoriteResult(message: error.rawValue, movie: movie)
        }
    }
}
