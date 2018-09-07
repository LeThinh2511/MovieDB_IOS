//
//  GenreCollectionViewCell.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/4/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

protocol GenreCollectionViewCellDelegate: class {
    func didTapGenreButton(genreID: Int)
}

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var genreButton: UIButton!
    @IBOutlet weak var containerView: UIView!

    var genreID: Int!
    weak var delegate: GenreCollectionViewCellDelegate?

    @IBAction func didTapGenreButton(_ sender: Any) {
        self.delegate?.didTapGenreButton(genreID: self.genreID)
    }

    func addTo(contentView: UIView) {
        self.containerView.add(toView: contentView)
    }
}
