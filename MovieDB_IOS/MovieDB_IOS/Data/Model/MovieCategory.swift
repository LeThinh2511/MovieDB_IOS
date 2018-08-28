//
//  MovieCategory.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/16/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

class MovieCategory {
    let name: String
    var movies = [Movie]()

    init(name: String) {
        self.name = name
    }
}
