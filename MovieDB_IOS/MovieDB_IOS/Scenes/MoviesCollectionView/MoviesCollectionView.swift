//
//  MoviesCollectionView.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/27/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class MoviesCollectionView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!

    var movies = [Movie]()
    weak var movieCollectionViewCellDelegate: MovieCollectionViewCellDelegate!

    override func awakeFromNib() {
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
}

extension MoviesCollectionView: UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                      for: indexPath) as? MovieCollectionViewCell
        if let cell = cell {
            let movie = movies[indexPath.row]
            cell.configMovieCollectionViewCell(movie: movie, contentView: cell.contentView)
            cell.delegate = movieCollectionViewCellDelegate
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.collectionItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constant.cellSize
    }
}
