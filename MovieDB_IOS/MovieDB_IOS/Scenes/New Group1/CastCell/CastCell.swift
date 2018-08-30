//
//  CastCell.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/22/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class CastCell: UICollectionViewCell {
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    weak var delegate: PersonItemDelegate?
    var person: Person!

    func configPersonItem(person: Person?, contentView: UIView) {
        guard let personTemp = person else {
            return
        }
        self.person = personTemp
        self.containView.add(toView: contentView)
        if let urlPath = personTemp.profilePath {
            let url = constructURLImage(path: urlPath)
            imageView.loadImage(from: url)
        }
        if let name = personTemp.name {
            nameLabel.text = name
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap(gestureRecognizer:)))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func imageViewDidTap(gestureRecognizer: UIGestureRecognizer) {
        self.delegate?.didTapPersonItem(person: self.person)
    }
}
