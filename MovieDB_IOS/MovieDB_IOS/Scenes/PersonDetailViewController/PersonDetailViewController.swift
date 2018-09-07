//
//  PersonDetailViewController.swift
//  MovieDB_IOS
//
//  Created by Loc Le on 8/23/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class PersonDetailViewController: MoviesBaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLable: UILabel!
    @IBOutlet weak var deathdayLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var categories = [MovieCategory]()
    var person: Person!
    var presenter: PersonDetailPresenter!

    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = PersonDetailPresenter(view: self, remoteRepository: RemoteRepository.shared)
        presenter.loadCredits(personID: self.person.personID)
        configPersonDetailView()
        setUpTableView()
        self.showHUD(progressLabel: Message.loading)
    }

    override func viewDidLayoutSubviews() {
        Constant.cellSize.width = (view.frame.width
            - (Constant.numVisibleItem - 1) * Constant.collectionItemSpacing) / Constant.numVisibleItem
        Constant.cellSize.height = Constant.cellSize.width * Constant.collectionItemSizeRate
    }

    @IBAction func swipeHandler(_ sender: Any) {
        self.dismissWithCustomAnimation()
    }

    // MARK: function
    private func configPersonDetailView() {
        self.nameLabel.text = person.name ?? GeneralName.noInforLabel
        self.birthdayLable.text = person.birthday ?? GeneralName.noInforLabel
        self.deathdayLabel.text = person.deathday ?? GeneralName.noInforLabel
        self.hometownLabel.text = person.placeOfBirth ?? GeneralName.noInforLabel
        if let profilePath = self.person.profilePath {
            let urlString = constructURLImage(path: profilePath)
            self.imageView.loadImage(from: urlString)
        }
    }

    private func setUpTableView() {
        self.tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "MoviesTableViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constant.estimatedRowHeight
    }
}

extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell",
                                                                for: indexPath) as? MoviesTableViewCell
        if let cell = moviesTableViewCell {
            cell.moviesCollectionView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Constant.cellSize.height).isActive = true
            cell.heightAnchor.constraint(equalToConstant: Constant.cellSize.height).isActive = false
            cell.movieCollectionViewCellDelegate = self
            let category = categories[indexPath.row]
            cell.creditsLabel.text = category.name
            cell.movies = category.movies
            return cell
        }
        return UITableViewCell()
    }
}

extension PersonDetailViewController: PersonDetailView {
    func loadCreditsSuccess(categories: [MovieCategory]) {
        self.categories = categories
        tableView.reloadData()
        self.dismissHUD(isAnimated: true)
    }

    func loadCreditsFailure() {
        self.showMessage(title: GeneralName.appName, message: Message.loadDataFailure)
    }
}
