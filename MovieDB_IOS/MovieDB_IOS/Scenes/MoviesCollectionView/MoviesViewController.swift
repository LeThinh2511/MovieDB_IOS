//
//  MoviesViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/31/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class MoviesViewController: MoviesBaseViewController {
    var movies = [Movie]()
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func setUpView() {
        navigationItem.title = name
        let moviesCollectionView = Bundle.main.loadNibNamed("MoviesCollectionView",
                                                            owner: nil, options: nil)?.first as? MoviesCollectionView
        if let view = moviesCollectionView {
            view.movies = self.movies
            view.nameLabel.text = self.name
            view.movieCollectionViewCellDelegate = self
            view.collectionView.reloadData()
            self.view = view
        }
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler))
        view.addGestureRecognizer(swipeGesture)
    }

    @objc private func swipeGestureHandler() {
        self.dismissWithCustomAnimation()
    }
}
