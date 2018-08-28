//
//  CategoryViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/16/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoryViewController: UIViewController, CategoryView, MovieItemDelegate {
    var categories = [MovieCategory]()
    var genres = [Genre]()
    var presenter: CategoryPresenter!

    @IBOutlet weak var leftSideViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var mainTableView: UITableView!

    @IBAction func toggleLeftSideMenu(_ sender: UIButton) {
        if leftSideViewleadingConstraint.priority == UILayoutPriority(rawValue: Constant.activeConstraint) {
            leftSideViewleadingConstraint.priority = UILayoutPriority(rawValue: Constant.inactiveConstraint)
        } else {
            leftSideViewleadingConstraint.priority = UILayoutPriority(rawValue: Constant.activeConstraint)
        }
        UIView.animate(withDuration: Constant.durationAnimationTime) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: life cycle
    override func viewDidLoad() {
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.estimatedRowHeight = Constant.estimatedRowHeight
        self.presenter = CategoryPresenter(view: self, remoteRepository: RemoteRepository.shared)
        presenter.loadData()
        genres = Genre.allCases
    }

    override func viewDidLayoutSubviews() {
        Constant.cellSize.width = (view.frame.width
            - (Constant.numVisibleItem - 1) * Constant.collectionItemSpacing) / Constant.numVisibleItem
        Constant.cellSize.height = Constant.cellSize.width * Constant.collectionItemSizeRate
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    // MARK: control function

    func movieItemTapped(movie: Movie) {
        let movieDetailViewController = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        movieDetailViewController.movie = movie
        self.present(movieDetailViewController, animated: true, completion: nil)
    }

    func loadDataSuccess(categories: [MovieCategory]) {
        self.categories = categories
        mainTableView.reloadData()
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mainTableView {
            return categories.count
        } else if tableView == self.leftTableView {
            return genres.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.mainTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",
                                                        for: indexPath) as? CategoryCell {
                let category = self.categories[indexPath.row]
                cell.nameLabel.text = category.name
                let height = Constant.cellSize.height
                cell.moviesCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
                return cell
            }
        } else if tableView == self.leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftTableViewCell", for: indexPath)
            let genre = self.genres[indexPath.row]
            cell.textLabel?.text = String(describing: genre).capitalized
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.mainTableView, let categoryCell = cell as? CategoryCell {
            categoryCell.setDataSourceDelegate(target: self, row: indexPath.row)
        }
    }
}

extension CategoryViewController: UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories[collectionView.tag].movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)
        let movie = categories[collectionView.tag].movies[indexPath.row]
        let movieItemTemp = Bundle.main.loadNibNamed("MovieItem", owner: nil, options: nil)?.first as? MovieItem
        guard let movieItem = movieItemTemp else {
            return cell
        }
        movieItem.configMovieItem(movie: movie)
        movieItem.delegate = self
        movieItem.add(toView: cell.contentView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constant.cellSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.collectionItemSpacing
    }
}
