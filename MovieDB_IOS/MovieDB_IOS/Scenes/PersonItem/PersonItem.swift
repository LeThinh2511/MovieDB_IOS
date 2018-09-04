//
//  PersonItem.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/20/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

protocol PersonItemDelegate: class {
    func didTapPersonItem(person: Person)
}

class PersonItem: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    weak var delegate: PersonItemDelegate?
    var person: Person!

    func configPersonItem(person: Person?) {
        guard let personTemp = person else {
            return
        }
        self.person = personTemp
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
