//
//  MovieDetailViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/20/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import Cosmos

class MovieDetailViewController: UIViewController {

    // MARK: Connection
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var averageVote: CosmosView!
    @IBOutlet weak var producerItem: UIView!
    @IBOutlet weak var castCollectionView: UICollectionView!

    var movie: Movie!
    private var cast: [Person]!
    private var producer: Person!
    private var presenter: MovieDetailPresenter!

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieDetailPresenter(view: self, repository: RemoteRepository.shared)
        presenter.getCast(from: self.movie)
        castCollectionView.register(UINib(nibName: "CastCell", bundle: nil), forCellWithReuseIdentifier: "CastCell")
        configMovieDetailView()
        self.showHUD(progressLabel: Message.loading)
    }

    override func viewDidLayoutSubviews() {
        Constant.cellSize.width = (view.frame.width
            - (Constant.numVisibleItem - 1) * Constant.collectionItemSpacing) / Constant.numVisibleItem
        Constant.cellSize.height = Constant.cellSize.width * Constant.collectionItemSizeRate
        castCollectionView.heightAnchor.constraint(
            greaterThanOrEqualToConstant: Constant.cellSize.height).isActive = true
    }

    @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        self.dismissWithCustomAnimation()
    }

    // MARK: function

    private func configMovieDetailView() {
        if let backdropPath = movie.backdropPath {
            let backdropURL = constructURLImage(path: backdropPath)
            backdropImageView.loadImage(from: backdropURL)
        }
        if let posterPath = movie.posterPath {
            let posterURL = constructURLImage(path: posterPath)
            posterImageView.loadImage(from: posterURL)
        }

        if let voteCount = movie.voteCount {
            self.voteCount.text = "(\(voteCount))"
        }

        if let voteAverage = movie.voteAverage {
            self.averageVote.rating = voteAverage
        }
        movieName.text = movie.title
    }
}

extension MovieDetailViewController: UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cast?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as? CastCell
        if let cell = cell {
            let person = cast[indexPath.row]
            cell.delegate = self
            cell.configPersonItem(person: person, contentView: cell.contentView)
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
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.collectionItemSpacing
    }
}

extension MovieDetailViewController: MovieDetailView {
    func getCreditsSuccess(cast: [Person], producer: Person?) {
        self.cast = cast
        self.producer = producer
        let personItem = Bundle.main.loadNibNamed("PersonItem", owner: nil, options: nil)?.first as? PersonItem
        if let personItem = personItem {
            personItem.configPersonItem(person: producer)
            personItem.delegate = self
            personItem.add(toView: self.producerItem)
            self.producerItem.heightAnchor.constraint(equalToConstant: Constant.cellSize.height).isActive = true
            self.producerItem.widthAnchor.constraint(equalToConstant: Constant.cellSize.width).isActive = true
        }
        castCollectionView.reloadData()
        self.dismissHUD(isAnimated: true)
    }

    func getCastFailure() {
        self.showMessage(title: GeneralName.appName, message: Message.loadDataFailure)
    }

    func getPersonFailure() {
        self.showMessage(title: GeneralName.appName, message: Message.loadDataFailure)
    }

    func navigateToPersonDetail(person: Person) {
        let personDetailViewController = PersonDetailViewController(nibName: "PersonDetailViewController", bundle: nil)
        personDetailViewController.person = person
        navigationController?.pushViewController(personDetailViewController, animated: true)
        self.dismissHUD(isAnimated: true)
    }
}

extension MovieDetailViewController: PersonItemDelegate {
    func didTapPersonItem(person: Person) {
        self.showHUD(progressLabel: Message.loading)
        self.presenter.getPerson(personID: person.personID)
    }
}
