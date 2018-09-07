//
//  MovieDetailPresenter.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/20/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import RxSwift

class MovieDetailPresenter: MovieDetailPresenterProtocol {

    private weak var view: MovieDetailView!
    private var repository: RemoteRepository!
    private let disposeBag = DisposeBag()

    init(view: MovieDetailView, repository: RemoteRepository) {
        self.repository = repository
        self.view = view
    }

    func getCast(from movie: Movie) {
        guard let id = movie.movieID else {return}
        repository.getMovieCredits(withId: id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (cast, crew) in
                let job = "Producer"
                let producer = crew.filter({ (person) -> Bool in
                    return person.job == job
                }).first
                self?.view.getCreditsSuccess(cast: cast, producer: producer)
                }, onError: { [weak self] (_) in
                    self?.view.getDataFailure()
                })
            .disposed(by: disposeBag)
    }

    func getPerson(personID: Int) {
        self.repository.getPerson(withID: personID)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] person in
                self?.view.navigateToPersonDetail(person: person)
                }, onError: { [weak self] _ in
                    self?.view.getDataFailure()
            })
            .disposed(by: disposeBag)
    }

    func getMovieWithTrailerPath(movieID: Int) {
        self.repository.getMovie(withId: movieID)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (movie) in
                self?.view.getMovieWithTrailerPathSuccess(movie: movie)
                }, onError: { [weak self] _ in
                    self?.view.getDataFailure()
            })
            .disposed(by: disposeBag)
    }

    func loadGenreMovies(genreID: Int) {
        self.repository.getGenreMovie(genreID: genreID, page: Constant.defaultPage)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (movies) in
                self?.view.loadGenreMoviesSuccess(movies: movies, genreID: genreID)
                }, onError: { [weak self] _ in
                    self?.view.getDataFailure()
            })
            .disposed(by: disposeBag)
    }
}
