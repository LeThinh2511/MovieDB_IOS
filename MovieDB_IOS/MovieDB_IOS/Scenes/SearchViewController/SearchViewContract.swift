//
//  SearchViewContract.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/27/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

protocol SearchView: class {
    func searchSuccess(movies: [Movie])
}

protocol SearchViewPresenterProtocol: class {
    func search(keyword: String, genre: String?, category: String?)
}
