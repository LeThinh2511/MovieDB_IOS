//
//  SearchViewPresenter.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/27/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import RxSwift

class SearchViewPresenter: SearchViewPresenterProtocol {

    private weak var view: SearchView!
    private let repository: RemoteRepository!

    private let disposeBag = DisposeBag()

    init(view: SearchView, repository: RemoteRepository) {
        self.view = view
        self.repository = repository
    }

    func search(keyword: String, genre: String?, category: String?) {
        repository.searchMovie(query: keyword, page: Constant.defaultPage)
            .observeOn(MainScheduler.instance)
            .map({ (movies) -> [Movie] in
                self.movieFilter(movies: movies, genre: genre, category: category)
            })
            .subscribe(onNext: { [weak self] (movies) in
                self?.view.searchSuccess(movies: movies)
            }, onError: nil, onCompleted: nil)
            .disposed(by: disposeBag)
    }

    private func movieFilter(movies: [Movie], genre: String?, category: String?) -> [Movie] {
        return movies // TODOs: Edit later
    }
}
