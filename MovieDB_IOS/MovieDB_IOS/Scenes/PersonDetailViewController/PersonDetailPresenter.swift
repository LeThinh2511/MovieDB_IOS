//
//  PersonDetailPresenter.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/23/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import RxSwift

class PersonDetailPresenter: PersonDetailPresenterProtocol {

    private weak var view: PersonDetailView!
    private var remoteRepository: RemoteRepository!

    private var disposeBag = DisposeBag()

    init(view: PersonDetailView, remoteRepository: RemoteRepository) {
        self.view = view
        self.remoteRepository = remoteRepository
    }

    func loadCredits(personID: Int) {
        remoteRepository.getMoviesFromPerson(withID: personID)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (cast, crew) in
                var categories = [MovieCategory]()
                if let cast = cast, !cast.isEmpty {
                        let category = MovieCategory(name: GeneralName.castLabel)
                        category.movies = cast
                        categories.append(category)
                }
                if let crew = crew, !crew.isEmpty {
                        let category = MovieCategory(name: GeneralName.crewLabel)
                        category.movies = crew
                        categories.append(category)
                }
                self?.view.loadCreditsSuccess(categories: categories)
                }, onError: { [weak self] _ in
                self?.view.loadCreditsFailure()
            })
            .disposed(by: disposeBag)
    }
}
