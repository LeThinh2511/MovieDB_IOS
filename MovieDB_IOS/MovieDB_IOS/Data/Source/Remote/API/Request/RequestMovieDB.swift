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

    func buildRequest(field: FieldMovieDB, queryID: Int?, parameters: [String: Any]?) -> URLRequest? {
        let path: String
        let url: String
        var queryItems = [URLQueryItem]()
        let baseParams = ["api_key": API.apiKey, "language": "en-US"]
        addingQueryItems(to: &queryItems, parameters: baseParams)
        if let parameters = parameters {
            addingQueryItems(to: &queryItems, parameters: parameters)
        }
        if let id = queryID {
            path = insertID(toField: field.rawValue, identifier: id)
            url = API.baseAPIURL + path
        } else {
            url = API.baseAPIURL + field.rawValue
        }
        var components = URLComponents(string: url)
        components?.queryItems = queryItems
        guard let urlComponents = components?.url else { return nil }
        return URLRequest(url: urlComponents)
    }

    // func to append fieldMovieDB when query has id
    private func insertID(toField path: String, identifier: Int) -> String {
        var editPath = path
        let pathSeparator: Character = "/"
        let tempIndex = editPath.index(of: pathSeparator)
        if let index = tempIndex {
            let indexToInsert = editPath.index(after: index)
            if indexToInsert.encodedOffset == editPath.count {
                editPath.append(String(identifier))
            } else {
                let idString = "/\(identifier)"
                editPath.insert(contentsOf: idString, at: index)
            }
            return editPath
        }
        return editPath + String(pathSeparator) + String(identifier)
    }

    // func to append queryItems with parameters
    private func addingQueryItems(to queryItems: inout [URLQueryItem], parameters: [String: Any]) {
        for (key, value) in parameters {
            let valueString = String(describing: value)
            let queryItem = URLQueryItem(name: key, value: valueString)
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
