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
    var name: String?
    var personID: Int!
    var birthday: String?
    var knownForDepartment: String?
    var deathday: String?
    var gender: Gender?
    var biography: String?
    var popularity: Double?
    var placeOfBirth: String?
    var profilePath: String?
    var job: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map[PersonModel.namePerson]
        personID <- map[PersonModel.personIDPerson]
        birthday <- map[PersonModel.birthdayPerson]
        knownForDepartment <- map[PersonModel.knownForDepartmentPerson]
        deathday <- map[PersonModel.deathdayPerson]
        gender <- map[PersonModel.genderPerson]
        biography <- map[PersonModel.biographyPerson]
        popularity <- map[PersonModel.popularityPerson]
        placeOfBirth <- map[PersonModel.placeOfBirthPerson]
        profilePath <- map[PersonModel.profilePathPerson]
        job <- map[PersonModel.jobPerson]
    }
}
