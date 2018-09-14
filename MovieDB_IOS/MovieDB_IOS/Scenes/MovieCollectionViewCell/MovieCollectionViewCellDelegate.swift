//
//  MovieCollectionViewCellDelegate.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/1/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

protocol MovieCollectionViewCellDelegate: class {
    func didTapMovieCollectionViewCell(movie: Movie)
    func didTapFavoriteButton(movie: Movie)
}
