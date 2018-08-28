//
//  MovieDetailViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/20/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import Cosmos

class MovieDetailViewController: UIViewController, MovieDetailView {

    var movie: Movie!
    var cast: [Person]!
    var producer: Person!
    var presenter: MovieDetailPresenter!

    // MARK: Connection
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var averageVote: CosmosView!
    @IBOutlet weak var producerItem: UIView!
    @IBOutlet weak var castCollectionView: UICollectionView!

    @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieDetailPresenter(view: self, repository: RemoteRepository.shared)
        presenter.getCast(from: self.movie)
        castCollectionView.register(CastCell.self, forCellWithReuseIdentifier: "CastCell")
        configMovieDetailView()
    }

    override func viewDidLayoutSubviews() {
        Constant.cellSize.width = (view.frame.width
            - (Constant.numVisibleItem - 1) * Constant.collectionItemSpacing) / Constant.numVisibleItem
        Constant.cellSize.height = Constant.cellSize.width * Constant.collectionItemSizeRate
        castCollectionView.heightAnchor.constraint(
            greaterThanOrEqualToConstant: Constant.cellSize.height).isActive = true
    }

    // MARK: function
    func getCreditsSuccess(cast: [Person], producer: Person?) {
        self.cast = cast
        self.producer = producer
        let personItem = Bundle.main.loadNibNamed("PersonItem", owner: nil, options: nil)?.first as? PersonItem
        if let personItem = personItem {
            personItem.configPersonItem(person: producer)
            personItem.add(toView: self.producerItem)
            self.producerItem.heightAnchor.constraint(equalToConstant: Constant.cellSize.height).isActive = true
            self.producerItem.widthAnchor.constraint(equalToConstant: Constant.cellSize.width).isActive = true
        }
        castCollectionView.reloadData()
    }

    func getCastFailure() {
        print("Nothing to show") //TODOs : EDIT LATER
    }

    private func configMovieDetailView() {
        guard let backdropPath = movie.backdropPath, let posterPath = movie.posterPath, let title = movie.title  else {
            return
        }
        guard let voteCount = movie.voteCount, let voteAverage = movie.voteAverage else {
            return
        }
        let backdropURL = constructURLImage(path: backdropPath)
        let posterURL = constructURLImage(path: posterPath)
        backdropImageView.loadImage(from: backdropURL)
        posterImageView.loadImage(from: posterURL)
        movieName.text = title
        self.voteCount.text = "(\(voteCount))"
        self.averageVote.rating = voteAverage
    }
}

extension MovieDetailViewController: UICollectionViewDataSource,
            UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cast = self.cast {
            return cast.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath)
        let actor = cast[indexPath.row]
        let personItemTemp = Bundle.main.loadNibNamed("PersonItem", owner: nil, options: nil)?.first as? PersonItem
        guard let personItem = personItemTemp else {
            return cell
        }
        personItem.configPersonItem(person: actor)
        personItem.add(toView: cell.contentView)
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
