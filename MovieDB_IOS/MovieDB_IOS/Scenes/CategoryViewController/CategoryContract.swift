//
//  CategoryContract.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/24/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

protocol CategoryPresenterProtocol {
    func loadData()
}

protocol CategoryView: class {
    func loadDataSuccess(categories: [MovieCategory])
    func toggleLeftSideMenu(_ sender: UIButton)
}
