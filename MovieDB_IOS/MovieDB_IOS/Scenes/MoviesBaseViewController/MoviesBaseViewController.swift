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
    func removeFavoriteResult(message: String, cell: MovieCollectionViewCell) {
        if message == Message.addToFavoriteSuccessful {
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        }
        self.showMessage(title: GeneralName.appName, message: message)
    }

    func insertFavoriteResult(message: String, cell: MovieCollectionViewCell) {
        if message == Message.deleteFavoriteMovie {
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "unfavorite"), for: .normal)
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

    func didTapFavoriteButton(movie: Movie, cell: MovieCollectionViewCell) {
        self.presenter.toggleFavoriteMovie(movie: movie, cell: cell)
    }
}
