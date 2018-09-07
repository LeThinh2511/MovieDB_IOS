//
//  GenreCell.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/1/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

protocol GenreCellDelegate: class {
    func didTapGenreButton(genreID: Int)
}

class GenreCell: UITableViewCell {

    @IBOutlet weak var genreButton: UIButton!

    var genreID: Int!
    weak var delegate: GenreCellDelegate?

    @IBAction func didTapGenreButton(_ sender: Any) {
        delegate?.didTapGenreButton(genreID: self.genreID)
    }
}
