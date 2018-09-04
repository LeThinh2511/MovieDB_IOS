//
//  File.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/23/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import Cosmos

protocol MovieCollectionViewCellDelegate: class {
    func didTapMovieCollectionViewCell(movie: Movie)
}

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var numVoteLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateView: CosmosView!

    weak var delegate: MovieCollectionViewCellDelegate?
    var movie: Movie!

    @IBAction func toggleFavorite(_ sender: Any) {
        print("toggle favorite") // TODOs: Edit later
    }

    func configMovieCollectionViewCell(movie: Movie, contentView: UIView) {
        self.movie = movie
        self.containerView.add(toView: contentView)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(tapGestureRecognizer:)))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func didTapImageView(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.didTapMovieCollectionViewCell(movie: movie)
    }
}
