//
//  PersonDetailContract.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/24/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

protocol PersonDetailPresenterProtocol: class {
    func loadCredits(personID: Int)
}

protocol PersonDetailView: class {
    func loadCreditsSuccess(categories: [MovieCategory])
}
