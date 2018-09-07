//
//  SearchViewController.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/25/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import DropDown

class SearchViewController: MoviesBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchOptionView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var genreButton: UIButton!

    private var moviesFound = [Movie]()
    private var genresOption = [String]()
    private var categoryOption = [String]()
    private var genresDropDown = DropDown()
    private var categoryDropDown =  DropDown()
    private var presenter: SearchViewPresenter!
    private var genreID: Int?
    private let genres = Genre.allCases

    // MARK: LIFE CYCLE

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        presenter = SearchViewPresenter(view: self, repository: RemoteRepository.shared)
        collectionView.register(UINib(nibName: "MovieCollectionViewCell",
                                      bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }

    @IBAction func genresButtonTapped(_ sender: Any) {
        genresDropDown.show()
    }

    @IBAction func categoryButtonTapped(_ sender: Any) {
        categoryDropDown.show()
    }

    // MARK: CONFIG VIEW
    private func setUpUI() {
        addOptions()
        addDropDown(dropdown: genresDropDown, to: genreButton, dataSource: genresOption)
        addDropDown(dropdown: categoryDropDown, to: categoryButton, dataSource: categoryOption)
        self.addDismissKeyboardRecognizer()
    }

    private func addOptions() {
        genresOption.append(GeneralName.allString)
        for genre in genres {
            let option = String(describing: genre)
            genresOption.append(option.capitalized)
        }
        categoryOption.append(GeneralName.allString)
        categoryOption.append(GeneralName.popularMovie)
        categoryOption.append(GeneralName.topRateMovie)
        categoryOption.append(GeneralName.upcomingMovie)
        categoryOption.append(GeneralName.nowPlayingMovie)
    }

    private func addDropDown(dropdown: DropDown, to button: UIButton, dataSource: [String]) {
        dropdown.anchorView = button
        dropdown.dataSource = dataSource
        dropdown.direction = .bottom
        let offset = dropdown.anchorView?.plainView.bounds.height
        if let offset = offset {
            dropdown.bottomOffset = CGPoint(x: 0, y: offset)
        }
        dropdown.selectionAction = { (index: Int, item: String) in
            button.setTitle(item, for: .normal)
            self.genreID = index == 0 ? nil : self.genres[index - 1].rawValue
        }
    }
}

extension SearchViewController: UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesFound.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                      for: indexPath) as? MovieCollectionViewCell
        if let cell = cell {
            let movie = moviesFound[indexPath.row]
            cell.delegate = self
            cell.configMovieCollectionViewCell(movie: movie, contentView: cell.contentView)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constant.cellSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.collectionItemSpacing
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        if let keyword = keyword, !keyword.isEmpty {
            self.showHUD(progressLabel: Message.loading)
            presenter.search(keyword: keyword, genreID: genreID, category: nil)
        } else {
            self.showMessage(title: GeneralName.appName, message: Message.searchTextEmptyMessage)
        }
    }
}

extension SearchViewController: SearchView {
    func searchSuccess(movies: [Movie]) {
        moviesFound = movies
        noResultLabel.isHidden = !movies.isEmpty
        collectionView.reloadData()
        self.dismissHUD(isAnimated: true)
    }

    func searchFailure() {
        self.showMessage(title: GeneralName.appName, message: Message.errorMessage)
    }
}
