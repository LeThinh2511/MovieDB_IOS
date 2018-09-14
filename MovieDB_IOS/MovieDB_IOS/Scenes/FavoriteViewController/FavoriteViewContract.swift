//
//  FavoriteViewContract.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/27/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

protocol FavoriteView: class {
    func loadFavoriteMovieSuccess(movies: [Movie]?)
    func loadFavoriteMovieFailure(error: SQLiteError)
    func addObserverFailure(message: String)
}

protocol FavoriteViewPresenterProtocol: class {
    func loadFavoriteMovies()
    func insertMovie(movie: Movie)
    func removeMovie(movie: Movie)
    func addRemoteObserver()
}
