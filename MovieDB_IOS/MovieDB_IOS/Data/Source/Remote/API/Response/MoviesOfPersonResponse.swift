//
//  MoviesOfPersonResponse.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/14/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import ObjectMapper

class MoviesOfPersonResponse: BaseResponse {
    var cast: [Movie]?
    var crew: [Movie]?

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        cast <- map["credits.cast"]
        crew <- map["credits.crew"]
    }
}
