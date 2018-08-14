//
//  MoviesResponse.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/14/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import ObjectMapper

class MoviesResponse: BaseResponse {
    var page: Int!
    var totalResults: Int!
    var totalPages: Int!
    var results = [Movie]()

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        page <- map["page"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
        results <- map["results"]
    }
}
