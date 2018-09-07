//
//  MovieDetailContract.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/24/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

protocol MovieDetailView: class {
    func getCreditsSuccess(cast: [Person], producer: Person?)
    func getDataFailure()
    func navigateToPersonDetail(person: Person)
    func getMovieWithTrailerPathSuccess(movie: Movie)
    func loadGenreMoviesSuccess(movies: [Movie], genreID: Int)
}

protocol MovieDetailPresenterProtocol {
    func getCast(from: Movie)
    func getPerson(personID: Int)
    func getMovieWithTrailerPath(movieID: Int)
    func loadGenreMovies(genreID: Int)
}
