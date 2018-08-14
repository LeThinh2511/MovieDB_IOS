//
//  MovieCreditsResponse.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/14/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieCreditsResponse: BaseResponse {
    var movieID: Int!
    var cast = [Person]()
    var crew = [Person]()

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        cast <- map["cast"]
        crew <- map["crew"]
        movieID <- map["id"]
    }
}
