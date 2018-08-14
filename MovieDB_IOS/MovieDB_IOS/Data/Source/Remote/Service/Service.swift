//
//  Service.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/13/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import ObjectMapper

class Service {
    private let session = URLSession(configuration: .default)

    // Making request and return jsonString
    private func request(field: FieldMovieDB, quID: Int?, para: [String: String]?, comple: @escaping (String) -> Void) {
        let request = RequestMovieDB().buildRequest(field: field, queryID: quID, parameters: para)
        let dataTask = self.session.dataTask(with: request) { (data, _, error) in
            if let data = data {
                let jsonString = String(data: data, encoding: .utf8)
                comple(jsonString!)
            } else {
                print(error!)
            }
        }
        dataTask.resume()
    }
    func searchPerson(query: String, page: Int, completion: @escaping (([Person]?) -> Void)) {
        let params = ["query": query, "page": String(page)]
        self.request(field: .searchPerson, quID: nil, para: params) { (json) in
            let response = SearchPersonResponse(JSONString: json)
            let people: [Person]? = response?.results
            completion(people)
        }
    }
    // Search movie by a keyword
    func searchMovie(query: String, page: Int, completion: @escaping (([Movie]?) -> Void)) {
        let params = ["query": query, "page": String(page)]
        self.request(field: .searchMovie, quID: nil, para: params) { (json) in
            let response = MoviesResponse(JSONString: json)
            let movies: [Movie]? = response?.results
            completion(movies)
        }
    }

    // get all movies which is in a category
    func getMovies(whichIs field: FieldMovieDB, page: Int, completion: @escaping ([Movie]?) -> Void) {
        let params = ["page": String(page)]
        self.request(field: field, quID: nil, para: params) { (json) in
            let response = MoviesResponse(JSONString: json)
            let movies: [Movie]? = response?.results
            completion(movies)
        }
    }

    // get movie by id
    func getMovie(withId movieID: Int, completion: @escaping (Movie?) -> Void) {
        self.request(field: .movieDetail, quID: movieID, para: nil) { (json) in
            let movie = Movie(JSONString: json)
            completion(movie)
        }
    }

    // Get a person by id
    func getPerson(withID personID: Int, completion: @escaping (Person?) -> Void) {
        self.request(field: .personDetail, quID: personID, para: nil) { (json) in
            let person = Person(JSONString: json)
            completion(person)
        }
    }
    // Get all cast and crew from a movie
    func getMovieCredits(withId movieID: Int, completion: @escaping ([Person]?, [Person]?) -> Void) {
        self.request(field: .movieCredits, quID: movieID, para: nil) { (json) in
            let response = MovieCreditsResponse(JSONString: json)
            let cast: [Person]? = response?.cast
            let crew: [Person]? = response?.crew
            completion(cast, crew)
        }
    }
    // Get all movies which is produced by a producer or actor
    func getMoviesFromPerson(withID personID: Int, completion: @escaping ([Movie]?, [Movie]? ) -> Void) {
        self.request(field: .personDetail, quID: personID, para: ["append_to_response": "credits"]) { (json) in
            let response = MoviesOfPersonResponse(JSONString: json)
            let cast = response?.cast
            let crew = response?.crew
            completion(cast, crew)
        }
    }
}
