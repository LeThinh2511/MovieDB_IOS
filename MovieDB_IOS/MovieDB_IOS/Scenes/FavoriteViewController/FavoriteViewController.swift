//
//  FavoriteViewController.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/27/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import RxSwift

class FavoriteViewController: MoviesBaseViewController {

    @IBOutlet weak var collectionViewHolder: UIView!

    private var presenter: FavoriteViewPresenter!
    private var collectionView: MoviesCollectionView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        presenter = FavoriteViewPresenter(view: self, localRepository: LocalRepository.shared)
        presenter.loadFavoriteMovies()
        NotificationCenter.default
        .rx.notification(NotificationName.updateFavoriteMovies)
            .subscribe(onNext: {_ in
                self.updateFavoriteMovies()
            }, onError: { (error) in
                self.showMessage(title: GeneralName.appName, message: error.localizedDescription)
            })
        .disposed(by: disposeBag)
        self.presenter.addRemoteObserver()
    }

    @objc func updateFavoriteMovies() {
        presenter.loadFavoriteMovies()
    }

    private func addCollectionView() {
        self.collectionView = Bundle.main.loadNibNamed("MoviesCollectionView",
                                                       owner: nil, options: nil)?.first as? MoviesCollectionView
        collectionView.movieCollectionViewCellDelegate = self
        collectionView.add(toView: collectionViewHolder)
        collectionView.nameLabel.text = GeneralName.favoriteMovies
    }
}

extension FavoriteViewController: FavoriteView {
    func loadFavoriteMovieSuccess(movies: [Movie]?) {
        if let movies = movies {
            self.collectionView.movies = movies
            self.collectionView.nameLabel.text = GeneralName.favoriteMovies
            collectionView.collectionView.reloadData()
        }
    }

    func loadFavoriteMovieFailure(error: SQLiteError) {
        self.showMessage(title: GeneralName.appName, message: error.rawValue)
    }

    func addObserverFailure(message: String) {
        self.showMessage(title: GeneralName.appName, message: message)
    }
}
