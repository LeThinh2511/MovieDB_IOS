//
//  MoviesBaseViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/6/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class MoviesBaseViewController: UIViewController {
    private var presenter: MoviesBaseViewPresenter!

    override func viewDidLoad() {
        self.presenter = MoviesBaseViewPresenter(view: self, localRepository: LocalRepository.shared)
    }
}

extension MoviesBaseViewController: MoviesBaseView {
    func removeFavoriteResult(message: String, movie: Movie) {
        if message == Message.deleteFavoriteMovie {
            let movieIDString = String(describing: movie.movieID)
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: Constant.updateFavoriteMovie + movieIDString), object: nil)
        }
        self.showMessage(title: GeneralName.appName, message: message)
    }

    func insertFavoriteResult(message: String, movie: Movie) {
        if message == Message.addToFavoriteSuccessful {
            let movieIDString = String(describing: movie.movieID)
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: Constant.updateFavoriteMovie + movieIDString), object: nil)
        }
        self.showMessage(title: GeneralName.appName, message: message)
    }
}

extension MoviesBaseViewController: MovieCollectionViewCellDelegate {
    func didTapMovieCollectionViewCell(movie: Movie) {
        let movieDetailViewController = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        movieDetailViewController.movie = movie
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }

    func didTapFavoriteButton(movie: Movie) {
        self.presenter.toggleFavoriteMovie(movie: movie)
    }
}
