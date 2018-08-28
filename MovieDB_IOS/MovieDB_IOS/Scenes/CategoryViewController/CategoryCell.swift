//
//  CategoryCell.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/16/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    func setDataSourceDelegate<T: UICollectionViewDelegate>(target: T, row: Int) where T: UICollectionViewDataSource {
        moviesCollectionView.delegate = target
        moviesCollectionView.dataSource = target
        moviesCollectionView.tag = row
        moviesCollectionView.reloadData()
    }
}
