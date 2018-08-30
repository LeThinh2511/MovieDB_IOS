//
//  CategoryViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/16/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoryViewController: UIViewController, CategoryView, MovieCollectionViewCellDelegate {

    @IBOutlet weak var leftSideViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var mainTableView: UITableView!

    private var categories = [MovieCategory]()
    private var genres = [Genre]()
    private var presenter: CategoryPresenter!

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
    func loadDataSuccess(categories: [MovieCategory]) {
        self.categories = categories
        mainTableView.reloadData()
    }

    func didTapMovieCollectionViewCell(movie: Movie) {
        let movieDetailViewController = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        movieDetailViewController.movie = movie
        self.present(movieDetailViewController, animated: true, completion: nil)
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.mainTableView:
            return categories.count
        default:
            return genres.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.mainTableView:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",
                                                        for: indexPath) as? CategoryCell {
                let category = self.categories[indexPath.row]
                cell.movies = category.movies
                cell.movieCollectionViewCellDelegate = self
                cell.selectionStyle = .none
                cell.nameLabel.text = category.name
                let height = Constant.cellSize.height
                cell.moviesCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
                return cell
            }
            return UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftTableViewCell", for: indexPath)
            let genre = self.genres[indexPath.row]
            cell.textLabel?.text = String(describing: genre).capitalized
            return cell
        }
    }
}
