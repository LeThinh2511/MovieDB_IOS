//
//  FavoriteViewController.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/27/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionViewHolder: UIView!

    private var presenter: FavoriteViewPresenter!
    private var collectionView: MoviesCollectionView!

    override func viewDidLoad() {
        addCollectionView()
        presenter = FavoriteViewPresenter(view: self, localRepository: LocalRepository.shared)
    }
    
    private func addCollectionView() {
        self.collectionView = Bundle.main.loadNibNamed("MoviesCollectionView",
                                                       owner: nil, options: nil)?.first as? MoviesCollectionView
        collectionView.movieCollectionViewCellDelegate = self
        collectionView.add(toView: collectionViewHolder)
        collectionView.nameLabel.text = GeneralName.favoriteMovies
    }
}

extension FavoriteViewController: MovieCollectionViewCellDelegate {
    func didTapMovieCollectionViewCell(movie: Movie) {
        let movieDetailViewController = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        movieDetailViewController.movie = movie
        self.present(movieDetailViewController, animated: true, completion: nil)
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
}
