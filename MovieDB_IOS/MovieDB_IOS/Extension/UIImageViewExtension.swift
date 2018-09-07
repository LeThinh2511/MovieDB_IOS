//
//  UIImageViewExtension.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/17/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        let urlImage = URL(string: urlString)
        guard let url = urlImage else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, _, error) in
            if error != nil {
                self.image = #imageLiteral(resourceName: "defaultImage")
            } else {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    self.image = #imageLiteral(resourceName: "defaultImage")
                }
            }
        }.resume()
    }
}
