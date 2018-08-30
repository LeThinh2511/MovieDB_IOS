//
//  MoviesTableViewCell.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/23/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var creditsLabel: UILabel!

    var movies = [Movie]()
    weak var movieCollectionViewCellDelegate: MovieCollectionViewCellDelegate!

    override func awakeFromNib() {
        self.moviesCollectionView.delegate = self
        self.moviesCollectionView.dataSource = self
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
}

extension MoviesTableViewCell: UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                      for: indexPath) as? MovieCollectionViewCell
        if let cell = cell {
            let movie = movies[indexPath.row]
            cell.configMovieCollectionViewCell(movie: movie, contentView: cell)
            cell.delegate = movieCollectionViewCellDelegate
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constant.cellSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.collectionItemSpacing
    }
}
