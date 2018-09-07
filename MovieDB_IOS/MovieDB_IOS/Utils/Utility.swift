//
//  Utility.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/23/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

// MARK: general name
struct GeneralName {
    static let popularMovie = "Popular"
    static let topRateMovie = "Top Rate"
    static let nowPlayingMovie = "Now Playing"
    static let upcomingMovie = "Upcoming"
    static let castLabel = "Cast"
    static let crewLabel = "Crew"
    static let noInforLabel = "No Infomation"
    static let allString = "All"
    static let favoriteMovies = "Favorite Movies"
    static let appName = "MovieDB_IOS"
    static let favoriteMoviesTable = "movies"
    static let moviesPathExtension = "sqlite3"
    static let trailerLabel = "Trailer"
    static let seeMoreTitle = "see more"
    static let seeLessTitle = "see less"
}
// MARK: Alert message
struct Message {
    static let searchTextEmptyMessage = "Keyword is not provided!"
    static let addToFavoriteSuccessful = "Added to favorite"
    static let deleteFavoriteMovie = "Removed from favorite"
    static let createTableSuccessful = "Created table"
    static let loading = "Loading..."
    static let loadDataFailure = "Can not load data"
    static let errorMessage = "Error"
    static let noTrailerMessage = "This movie has no trailer"
}

// MARK: movie model
struct MovieModel {
    static let voteCountMovie = "vote_count"
    static let voteAverageMovie = "vote_average"
    static let titleMovie = "title"
    static let statusMovie = "status"
    static let revenueMovie = "revenue"
    static let releaseDateMovie = "release_date"
    static let popularityMovie = "popularity"
    static let overviewMovie = "overview"
    static let movieIDMovie = "id"
    static let budgetMovie = "budget"
    static let backdropPathMovie = "backdrop_path"
    static let posterPathMovie = "poster_path"
    static let favoriteMoviesTable = "movies"
    static let moviesPathExtension = "sqlite3"
    static let genreIDsMovie = "genre_ids"
    static let trailerPath = "videos.results.0.key"
}
// MARK: person model
struct PersonModel {
    static let namePerson = "name"
    static let personIDPerson = "id"
    static let birthdayPerson = "birthday"
    static let knownForDepartmentPerson = "known_for_department"
    static let deathdayPerson = "deathday"
    static let genderPerson = "gender"
    static let biographyPerson = "biography"
    static let popularityPerson = "popularity"
    static let placeOfBirthPerson = "place_of_birth"
    static let profilePathPerson = "profile_path"
    static let jobPerson = "job"
}

// MARK: GenreMovie model
struct GenreMovieModel {
    static let genreID = "id"
    static let genreName = "name"
}

// MARK: common value
struct Constant {
    static let durationAnimationTime = 0.3
    static let activeConstraint: Float  = 900
    static let inactiveConstraint: Float = 500
    static let collectionItemSpacing: CGFloat = 10
    static let numVisibleItem: CGFloat = 3
    static var collectionItemSizeRate: CGFloat = 1.75
    static var cellSize = CGSize(width: 0, height: 0)
    static let estimatedRowHeight: CGFloat = 197
    static let defaultPage = 1
    static var genreButtonSize = CGSize(width: 0, height: 30)
    static let numLineLabel = 2
}

struct API {
    static let apiKey = "a13cd0049bdd3d3275de11627248af15"
    static let baseAPIURL = "https://api.themoviedb.org/3/"
}

struct NotificationName {
    static let updateFavoriteMovies = NSNotification.Name(rawValue: "updateFavoriteMovies")
}

// MARK: Util function
func constructURLImage(path: String) -> String {
    let baseURL = "https://image.tmdb.org/t/p/w500"
    let url = baseURL + path
    return url
}
