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
            if let error = error {
                print(error) //TODOs : EDIT LATER
            } else {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.sync {
                        self.image = image
                    }
                } else {
                    //TODOs : EDIT LATER
                }
            }
        }.resume()
    }
}
