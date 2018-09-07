//
//  CategoryCell.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/16/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

protocol SeeAllButtonDelegate: class {
    func didTapSeeAllButton(movies: [Movie], categoryName: String?)
}

class CategoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    var movies = [Movie]()
    weak var movieCollectionViewCellDelegate: MovieCollectionViewCellDelegate!
    weak var delegate: SeeAllButtonDelegate?

    override func awakeFromNib() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }

    @IBAction func didTapSeeAllButton(_ sender: Any) {
        delegate?.didTapSeeAllButton(movies: self.movies, categoryName: self.nameLabel.text)
    }
}

extension CategoryCell: UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                      for: indexPath) as? MovieCollectionViewCell
        if let cell = cell {
            let movie = self.movies[indexPath.row]
            cell.delegate = movieCollectionViewCellDelegate
            cell.configMovieCollectionViewCell(movie: movie, contentView: cell.contentView)
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
