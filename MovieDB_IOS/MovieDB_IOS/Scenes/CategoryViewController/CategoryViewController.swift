//
//  CategoryViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/16/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoryViewController: MoviesBaseViewController {

    @IBOutlet weak var leftSideViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var mainTableView: UITableView!

    private var categories = [MovieCategory]()
    private var genres = [Genre]()
    private var presenter: CategoryPresenter!

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.estimatedRowHeight = Constant.estimatedRowHeight
        self.presenter = CategoryPresenter(view: self, remoteRepository: RemoteRepository.shared)
        presenter.loadData()
        genres = Genre.allCases
        self.showHUD(progressLabel: Message.loading)
    }

    override func viewDidLayoutSubviews() {
        Constant.cellSize.width = (view.frame.width
            - (Constant.numVisibleItem - 1) * Constant.collectionItemSpacing) / Constant.numVisibleItem
        Constant.cellSize.height = Constant.cellSize.width * Constant.collectionItemSizeRate
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBAction func didTapSettingButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }

    @IBAction func dismissLeftSideMenu(_ sender: Any) {
        leftSideViewleadingConstraint.priority = UILayoutPriority(rawValue: Constant.activeConstraint)
        UIView.animate(withDuration: Constant.durationAnimationTime) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func toggleLeftSideMenu(_ sender: UIBarButtonItem) {
        if leftSideViewleadingConstraint.priority == UILayoutPriority(rawValue: Constant.activeConstraint) {
            leftSideViewleadingConstraint.priority = UILayoutPriority(rawValue: Constant.inactiveConstraint)
        } else {
            leftSideViewleadingConstraint.priority = UILayoutPriority(rawValue: Constant.activeConstraint)
        }
        UIView.animate(withDuration: Constant.durationAnimationTime) {
            self.view.layoutIfNeeded()
        }
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.mainTableView:
            return categories.count
        case self.leftTableView:
            return genres.count
        default:
            return 0
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
                cell.delegate = self
                cell.selectionStyle = .none
                cell.nameLabel.text = category.name
                let height = Constant.cellSize.height
                cell.moviesCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
                return cell
            }
            return UITableViewCell()
        case self.leftTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as? GenreCell
            if let cell = cell {
                let genre = self.genres[indexPath.row]
                let buttonName = String(describing: genre).capitalized
                cell.genreButton.setTitle(buttonName, for: .normal)
                cell.delegate = self
                cell.genreID = genre.rawValue
                return cell
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension CategoryViewController: SeeAllButtonDelegate {
    func didTapSeeAllButton(movies: [Movie], categoryName: String?) {
        let viewController = MoviesViewController()
        viewController.movies = movies
        viewController.name = categoryName
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CategoryViewController: GenreCellDelegate {
    func didTapGenreButton(genreID: Int) {
        leftSideViewleadingConstraint.priority = UILayoutPriority(rawValue: Constant.activeConstraint)
        UIView.animate(withDuration: Constant.durationAnimationTime) {
            self.view.layoutIfNeeded()
        }
        self.showHUD(progressLabel: Message.loading)
        presenter.loadGenreMovies(genreID: genreID)
    }
}

extension CategoryViewController: CategoryView {
    func loadDataSuccess(categories: [MovieCategory]) {
        self.categories = categories
        mainTableView.reloadData()
        self.dismissHUD(isAnimated: true)
    }

    func loadGenreMoviesSuccess(movies: [Movie], genreID: Int) {
        let viewController = MoviesViewController()
        viewController.movies = movies
        let genre = Genre.init(rawValue: genreID)
        if let genre = genre {
            let genreName = String(describing: genre).capitalized
            viewController.name = genreName
        }
        navigationController?.pushViewController(viewController, animated: true)
        self.dismissHUD(isAnimated: true)
    }

    func loadDataFailure() {
        self.showMessage(title: GeneralName.appName, message: Message.loadDataFailure)
    }
}
