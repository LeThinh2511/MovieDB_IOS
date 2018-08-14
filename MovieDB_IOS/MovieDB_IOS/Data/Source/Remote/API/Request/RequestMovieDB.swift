//
//  RequestMovieDB.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/13/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

class RequestMovieDB {
    static let shared = RequestMovieDB()
    private let apiKey = "a13cd0049bdd3d3275de11627248af15"
    private let baseURL = "https://api.themoviedb.org/3/"
    func buildRequest(field: FieldMovieDB, queryID: Int?, parameters: [String: String]?) -> URLRequest {
        let path: String
        let url: String
        var queryItems = [URLQueryItem]()
        let baseParams = ["api_key": self.apiKey, "language": "en-US"]
        addingQueryItems(to: &queryItems, parameters: baseParams)
        if let parameters = parameters {
            addingQueryItems(to: &queryItems, parameters: parameters)
        }
        if let id = queryID {
            path = insertID(toField: field.rawValue, identifier: id)
            url = baseURL + path
        } else {
            url = baseURL + field.rawValue
        }
        var components = URLComponents(string: url)!
        components.queryItems = queryItems
        return URLRequest(url: components.url!)
    }
    // func to append fieldMovieDB when query has id
    private func insertID(toField path: String, identifier: Int) -> String {
        var editPath = path
        let index = editPath.index(after: editPath.index(of: "/")!)
        if index.encodedOffset == editPath.count {
            editPath.append(String(identifier))
        } else {
            let idString = "\(identifier)/"
            editPath.insert(contentsOf: idString, at: index)
        }
        return editPath
    }
    // func to append queryItems with parameters
    private func addingQueryItems(to queryItems: inout [URLQueryItem], parameters: [String: String]) {
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
    }
}

enum FieldMovieDB: String {
    case searchPerson = "search/person"
    case movieDetail = "movie/"
    case movieCredits = "movie/credits"
    case genreList = "genre/movie/list"
    case personDetail = "person/"
    case moviePopular = "movie/popular"
    case movieNowPlaying = "movie/now_playing"
    case movieUpcoming = "movie/upcoming"
    case movieTopRate = "movie/top_rated"
    case searchMovie = "search/movie"
}

enum RequestMovieDBError {
    case notProvidedID
}
