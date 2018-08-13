//
//  Person.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/11/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import ObjectMapper

enum Gender: Int {
    case male = 1
    case female = 0
}

class Person: Mappable {
    var name: String!
    var personID: Int!
    var birthday: String?
    var knownForDepartment: String!
    var deathday: String?
    var gender: Gender!
    var biography: String!
    var popularity: NSNumber!
    var placeOfBirth: String?
    var profilePath: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        personID <- map["id"]
        birthday <- map["birthday"]
        knownForDepartment <- map["knownForDepartment"]
        deathday <- map["deathday"]
        gender <- map["gender"]
        biography <- map["biography"]
        popularity <- map["popularity"]
        placeOfBirth <- map["placeOfBirth"]
        profilePath <- map["profilePath"]
    }
}
