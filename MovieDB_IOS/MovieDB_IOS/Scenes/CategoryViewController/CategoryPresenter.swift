//
//  CategoryPresenter.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/17/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import RxSwift

class CategoryPresenter: CategoryPresenterProtocol {
    private unowned var view: CategoryView
    private var remoteRepository: RemoteRepository
    private var disposeBag = DisposeBag()

    init(view: CategoryView, remoteRepository: RemoteRepository) {
        self.view = view
        self.remoteRepository = remoteRepository
    }

    func loadData() {
        var categoriesName = [String: FieldMovieDB]()
        categoriesName[GeneralName.popularMovie] = FieldMovieDB.moviePopular
        categoriesName[GeneralName.topRateMovie] = FieldMovieDB.movieTopRate
        categoriesName[GeneralName.nowPlayingMovie] = FieldMovieDB.movieNowPlaying
        categoriesName[GeneralName.upcomingMovie] = FieldMovieDB.movieUpcoming
        var categories = [MovieCategory]()
        for (key, value) in categoriesName {
            self.remoteRepository.getMovies(whichIs: value, page: 1)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] movies in
                    let category = MovieCategory(name: key)
                    category.movies = movies
                    categories.append(category)
                    self?.view.loadDataSuccess(categories: categories)
                    }, onError: { [weak self] _ in
                        self?.view.loadDataFailure()
                })
                .disposed(by: disposeBag)
        }
    }

    func loadGenreMovies(genreID: Int) {
        self.remoteRepository.getGenreMovie(genreID: genreID, page: Constant.defaultPage)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (movies) in
            self.view.loadGenreMoviesSuccess(movies: movies, genreID: genreID)
            }, onError: { [weak self] _ in
                self?.view.loadDataFailure()
        })
        .disposed(by: disposeBag)
    }
}
