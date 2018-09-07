//
//  BaseViewContract.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/6/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

protocol MoviesBaseView: class {
    func removeFavoriteResult(message: String, cell: MovieCollectionViewCell)
    func insertFavoriteResult(message: String, cell: MovieCollectionViewCell)
}

protocol MoviesBaseViewPresenterProtocol: class {
    func toggleFavoriteMovie(movie: Movie, cell: MovieCollectionViewCell)
}
