//
//  PersonItem.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/20/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

protocol PersonItemProtocol: class {
    func personItemTapped(person: Person)
}

class PersonItem: UIView {
    weak var delegate: PersonItemProtocol?
    var person: Person!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

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
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func imageViewDidTap(gestureRecognizer: UIGestureRecognizer) {
        self.delegate?.personItemTapped(person: self.person)
    }
}
