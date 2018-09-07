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

    func toggleFavoriteMovie(movie: Movie, cell: MovieCollectionViewCell) {
        let isMovieFavorite = localRepository.checkFavoriteMovie(movie: movie)
        if isMovieFavorite {
            removeMovie(movie: movie, cell: cell)
        } else {
            insertMovie(movie: movie, cell: cell)
        }
    }

    private func removeMovie(movie: Movie, cell: MovieCollectionViewCell) {
        let result = localRepository.deleteMovie(movie: movie)
        switch result {
        case .success(let message):
            self.view.removeFavoriteResult(message: message, cell: cell)
            NotificationCenter.default.post(name: NotificationName.updateFavoriteMovies, object: nil)
        case .failure(let error):
            self.view.removeFavoriteResult(message: error.rawValue, cell: cell)
        }
    }

    private func insertMovie(movie: Movie, cell: MovieCollectionViewCell) {
        let result = localRepository.insertMovie(movie: movie)
        switch result {
        case .success(let message):
            self.view.insertFavoriteResult(message: message, cell: cell)
            NotificationCenter.default.post(name: NotificationName.updateFavoriteMovies, object: nil)
        case .failure(let error):
            self.view.insertFavoriteResult(message: error.rawValue, cell: cell)
        }
    }
}
