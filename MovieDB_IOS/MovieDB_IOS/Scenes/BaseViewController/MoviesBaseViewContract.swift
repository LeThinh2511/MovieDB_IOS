//
//  MoviesBaseViewContract.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/6/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

protocol MoviesBaseView: class {
    func removeFavoriteResult(message: String, movie: Movie)
    func insertFavoriteResult(message: String, movie: Movie)
}

protocol MoviesBaseViewPresenterProtocol: class {
    func toggleFavoriteMovie(movie: Movie)
}
