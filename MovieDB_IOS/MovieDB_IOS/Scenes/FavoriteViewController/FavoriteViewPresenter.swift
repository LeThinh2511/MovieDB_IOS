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
}
