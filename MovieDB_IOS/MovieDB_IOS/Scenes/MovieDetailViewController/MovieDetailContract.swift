//
//  MovieDetailContract.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/24/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

protocol MovieDetailView: class {
    func getCreditsSuccess(cast: [Person], producer: Person?)
    func getCastFailure()
}

protocol MovieDetailPresenterProtocol {
    func getCast(from: Movie)
}
