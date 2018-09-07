//
//  Movie.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/11/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import ObjectMapper

class Movie: Mappable {
    var voteCount: Int?
    var voteAverage: Double?
    var title: String?
    var status: Status?
    var revenue: Int?
    var releaseDate: String?
    var popularity: Double?
    var overview: String?
    var movieID: Int!
    var genreIDs: [Int]?
    var budget: Int?
    var backdropPath: String?
    var posterPath: String?

    required init?(map: Map) {
    }

    init() {
    }

    func mapping(map: Map) {
        voteCount <- map[MovieModel.voteCountMovie]
        voteAverage <- map[MovieModel.voteAverageMovie]
        title <- map[MovieModel.titleMovie]
        status <- map[MovieModel.statusMovie]
        revenue <- map[MovieModel.revenueMovie]
        releaseDate <- map[MovieModel.revenueMovie]
        popularity <- map[MovieModel.popularityMovie]
        overview <- map[MovieModel.overviewMovie]
        movieID <- map[MovieModel.movieIDMovie]
        budget <- map[MovieModel.budgetMovie]
        backdropPath <- map[MovieModel.backdropPathMovie]
        posterPath <- map[MovieModel.posterPathMovie]
        genreIDs <- map[MovieModel.genreIDsMovie]
    }
}

enum Status {
    case rumored
    case planned
    case inProduction
    case postProduction
    case released
    case canceled
}

enum Genre: Int, Mappable, CaseIterable {

    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tVMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37

    init?(map: Map) {
        guard let id = map.JSON[MovieModel.movieIDMovie] as? Int else { return nil }
        self.init(rawValue: id)
    }

    mutating func mapping(map: Map) {
    }
}
