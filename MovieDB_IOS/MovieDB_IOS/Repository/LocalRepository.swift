//
//  LocalRepository.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/27/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import SQLite

class LocalRepository {

    private var connection: Connection!
    private let movies = Table(GeneralName.favoriteMoviesTable)
    private let voteCountCol = Expression<Int?>(MovieModel.voteCountMovie)
    private let voteAverageCol = Expression<Double?>(MovieModel.voteAverageMovie)
    private let titleCol = Expression<String?>(MovieModel.titleMovie)
    private let revenueCol = Expression<Int?>(MovieModel.revenueMovie)
    private let releaseDateCol = Expression<String?>(MovieModel.releaseDateMovie)
    private let popularityCol = Expression<Double?>(MovieModel.popularityMovie)
    private let overviewCol = Expression<String?>(MovieModel.overviewMovie)
    private let movieIDCol = Expression<Int>(MovieModel.movieIDMovie)
    private let budgetCol = Expression<Int?>(MovieModel.budgetMovie)
    private let backdropPathCol = Expression<String?>(MovieModel.backdropPathMovie)
    private let posterPathCol = Expression<String?>(MovieModel.posterPathMovie)

    static let shared: LocalRepository = {
        let localRepository = LocalRepository()
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent(
                GeneralName.favoriteMoviesTable).appendingPathExtension(GeneralName.moviesPathExtension)
            let connection = try Connection(fileURL.path)
            localRepository.connection = connection
        } catch {
        }
        return localRepository
    }()

    private init() {
    }

    @discardableResult
    func createTable() -> SQLiteResult<String> {
        do {
            try self.connection.run(movies.create(
                temporary: false, ifNotExists: true, withoutRowid: false, block: { (tableBuider) in
                    tableBuider.column(voteCountCol)
                    tableBuider.column(voteAverageCol)
                    tableBuider.column(titleCol)
                    tableBuider.column(revenueCol)
                    tableBuider.column(releaseDateCol)
                    tableBuider.column(popularityCol)
                    tableBuider.column(overviewCol)
                    tableBuider.column(budgetCol)
                    tableBuider.column(backdropPathCol)
                    tableBuider.column(posterPathCol)
                    tableBuider.column(movieIDCol, primaryKey: true)
            }))
            return .success(Message.createTableSuccessful)
        } catch {
            return .failure(.createTableFailure)
        }
    }

    func insertMovie(movie: Movie) -> SQLiteResult<String> {
        let insert = movies.insert(self.voteCountCol <- movie.voteCount,
                                   self.voteAverageCol <- movie.voteAverage,
                                   self.titleCol <- movie.title,
                                   self.revenueCol <- movie.revenue,
                                   self.releaseDateCol <- movie.releaseDate,
                                   self.popularityCol <- movie.popularity,
                                   self.overviewCol <- movie.overview,
                                   self.budgetCol <- movie.budget,
                                   self.backdropPathCol <- movie.backdropPath,
                                   self.posterPathCol <- movie.posterPath,
                                   self.movieIDCol <- movie.movieID)
        do {
            try connection.run(insert)
            return .success(Message.addToFavoriteSuccessful)
        } catch {
            return .failure(.insertFailure)
        }
    }

    func selectAllMovie() -> SQLiteResult<[Movie]> {
        do {
            var movies = [Movie]()
            let rows = try connection.prepare(self.movies)
            for row in rows {
                let movie = Movie()
                movie.movieID = row[movieIDCol]
                movie.voteCount = row[voteCountCol]
                movie.voteAverage = row[voteAverageCol]
                movie.title = row[titleCol]
                movie.revenue = row[revenueCol]
                movie.releaseDate = row[releaseDateCol]
                movie.popularity = row[popularityCol]
                movie.overview = row[overviewCol]
                movie.budget = row[budgetCol]
                movie.backdropPath = row[backdropPathCol]
                movie.posterPath = row[posterPathCol]
                movies.append(movie)
            }
            return .success(movies)
        } catch {
            return .failure(.selectFailure)
        }
    }

    func deleteMovie(movie: Movie) -> SQLiteResult<String> {
        let movieDelete = movies.filter(movieIDCol == movie.movieID)
        do {
            try connection.run(movieDelete.delete())
            return .success(Message.deleteFavoriteMovie)
        } catch {
            return .failure(.deleteFailure)
        }
    }

    func checkFavoriteMovie(movie: Movie) -> Bool {
        do {
            let count: Int = try connection.scalar(movies.where(movieIDCol == movie.movieID).count)
            return count == 1
        } catch {
            return false
        }
    }
}

enum SQLiteError: String, Error {
    case connetDatabaseFailure = "Can not connect to database"
    case createTableFailure = "Can not create table"
    case insertFailure = "Can not add movie to favorite movies"
    case selectFailure = "Can not load favorite movies"
    case deleteFailure = "Can not remove from favorite movies"
    case updateFailure = "Can not update movie"
}

enum SQLiteResult<T> {
    case success(T)
    case failure(SQLiteError)
}
