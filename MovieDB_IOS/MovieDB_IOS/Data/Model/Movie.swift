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
    var voteCount: Int!
    var voteAverage: NSNumber!
    var title: String!
    var status: Status!
    var revenue: Int!
    var releaseDate: String!
    var popularity: NSNumber!
    var overview: String?
    var movieID: Int!
    var genres: [Genre]!
    var budget: Int!
    var backdropPath: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        voteCount <- map["vote_count"]
        voteAverage <- map["vote_average"]
        title <- map["title"]
        status <- map["status"]
        revenue <- map["revenue"]
        releaseDate <- map["release_date"]
        popularity <- map["popularity"]
        overview <- map["overview"]
        movieID <- map["id"]
        budget <- map["budget"]
        backdropPath <- map["backdrop_path"]
        genres = map.JSON["genres"] as? [Genre]
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

enum Genre: Int, Mappable {

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
        guard let id = map.JSON["id"] as? Int else {return nil}
        self = Genre(rawValue: id)!
    }

    mutating func mapping(map: Map) {
    }
}
