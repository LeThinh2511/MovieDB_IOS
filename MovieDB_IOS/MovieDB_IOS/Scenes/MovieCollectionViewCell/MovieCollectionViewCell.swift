//
//  File.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/23/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import Cosmos
import RxSwift
import RxCocoa

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var numVoteLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateView: CosmosView!

    weak var delegate: MovieCollectionViewCellDelegate?
    var movie: Movie!
    private let localRepository = LocalRepository.shared
    private let disposeBag = DisposeBag()

    @IBAction func toggleFavorite(_ sender: Any) {
        delegate?.didTapFavoriteButton(movie: movie)
    }

    func configMovieCollectionViewCell(movie: Movie, contentView: UIView) {
        self.movie = movie
        self.containerView.add(toView: contentView)
        if let posterPath = movie.posterPath {
            let url = constructURLImage(path: posterPath)
            self.imageView.loadImage(from: url)
        }

        if localRepository.checkFavoriteMovie(movie: movie) {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        } else {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "unfavorite"), for: .normal)
        }

        if let rateAverage = movie.voteAverage, let voteCount = movie.voteCount {
            let rate = rateAverage / 2
            rateView.rating = rate
            numVoteLabel.text = "(\(voteCount))"
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(tapGestureRecognizer:)))
        imageView.addGestureRecognizer(tapGesture)

        NotificationCenter.default
            .rx.notification(NSNotification.Name(rawValue: Constant.updateFavoriteMovie
                + "\(movie.movieID)"))
            .subscribe(onNext: { _ in
                self.updateFavoriteMovie()
            })
        .disposed(by: disposeBag)
    }

    @objc func didTapImageView(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.didTapMovieCollectionViewCell(movie: movie)
    }

    private func updateFavoriteMovie() {
        let isFavorite = self.localRepository.checkFavoriteMovie(movie: self.movie)
        let image = isFavorite ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "unfavorite")
        self.favoriteButton.setImage(image, for: .normal)
    }
}
