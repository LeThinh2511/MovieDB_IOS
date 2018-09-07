//
//  RemoteRepository.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/15/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import RxSwift

class RemoteRepository {

    private let service: Service

    static let shared: RemoteRepository = {
        let service = Service.shared
        let remoteRepository = RemoteRepository(service: service)
        return remoteRepository
    }()

    private init(service: Service) {
        self.service = service
    }

    // Search person by keyword
    func searchPerson(query: String, page: Int) -> Observable<[Person]> {
        let params = ["query": query, "page": String(page)]
        let request = RequestMovieDB.shared.buildRequest(field: .searchPerson, queryID: nil, parameters: params)
        return service.request(request: request)
            .map({ (response: SearchPersonResponse) -> [Person] in
                return response.results
            })
    }
    // Search movie by a keyword
    func searchMovie(query: String, page: Int) -> Observable<[Movie]> {
        let params = ["query": query, "page": String(page)]
        let request = RequestMovieDB.shared.buildRequest(field: .searchMovie, queryID: nil, parameters: params)
        return service.request(request: request)
            .map({ (response: MoviesResponse) -> [Movie] in
                return response.results
            })
    }

    // get all movies which is in a category
    func getMovies(whichIs field: FieldMovieDB, page: Int) -> Observable<[Movie]> {
        let params = ["page": page]
        let request = RequestMovieDB.shared.buildRequest(field: field, queryID: nil, parameters: params)
        return service.request(request: request)
            .map({ (response: MoviesResponse) -> [Movie] in
                return response.results
            })
    }

    // get movie by id
    func getMovie(withId movieID: Int) -> Observable<Movie> {
        let request = RequestMovieDB.shared.buildRequest(field: .movieDetail, queryID: movieID, parameters: nil)
        return service.request(request: request)
    }

    // Get a person by id
    func getPerson(withID personID: Int) -> Observable<Person> {
        let request = RequestMovieDB.shared.buildRequest(field: .personDetail, queryID: personID, parameters: nil)
        return service.request(request: request)
    }

    // Get all cast and crew from a movie
    func getMovieCredits(withId movieID: Int) -> Observable<([Person], [Person])> {
        let request = RequestMovieDB.shared.buildRequest(field: .movieCredits, queryID: movieID, parameters: nil)
        return service.request(request: request)
            .map({ (response: MovieCreditsResponse) -> ([Person], [Person]) in
                return (response.cast, response.crew)
            })
    }
    // Get all movies which is produced by a producer or actor
    func getMoviesFromPerson(withID personID: Int) -> Observable<([Movie]?, [Movie]?)> {
        let param = ["append_to_response": "credits"]
        let request = RequestMovieDB.shared.buildRequest(field: .personDetail, queryID: personID, parameters: param)
        return service.request(request: request)
            .map({ (response: MoviesOfPersonResponse) -> ([Movie]?, [Movie]?) in
                return (response.cast, response.crew)
            })
    }

    // Get movies by genre
    func getGenreMovie(genreID: Int, page: Int) -> Observable<[Movie]> {
        let param = ["with_genres": genreID, "page": page]
        let request = RequestMovieDB.shared.buildRequest(field: .genreMovie, queryID: nil, parameters: param)
        return service.request(request: request)
            .map { (response: MoviesResponse) -> [Movie] in
                return response.results
        }
    }
}
