//
//  MovieItem.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/16/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import Cosmos

protocol MovieItemDelegate: class {
    func movieItemTapped(movie: Movie)
}

class MovieItem: UIView {

    weak var delegate: MovieItemDelegate?
    var movie: Movie!
    @IBOutlet weak var numVoteLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateView: CosmosView!
    @IBAction func toggleFavorite(_ sender: Any) {
        print("toggle favorite") // TODOs: Edit later
    }

    func configMovieItem(movie: Movie) {
        self.movie = movie
        if let posterPath = movie.posterPath {
            let url = constructURLImage(path: posterPath)
            self.imageView.loadImage(from: url)
        }
        self.favoriteButton.setImage(#imageLiteral(resourceName: "unfavorite"), for: .normal)

        if let rateAverage = movie.voteAverage, let voteCount = movie.voteCount {
            let rate = rateAverage / 2
            rateView.rating = rate
            numVoteLabel.text = "(\(voteCount))"
        }
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(MovieItem.imageViewTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func imageViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.movieItemTapped(movie: self.movie)
    }
}
