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
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton!

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
        genresCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "GenreCollectionViewCell")
        configMovieDetailView()
        self.showHUD(progressLabel: Message.loading)
    }

    override func viewDidLayoutSubviews() {
        Constant.cellSize.width = (view.frame.width
            - (Constant.numVisibleItem - 1) * Constant.collectionItemSpacing) / Constant.numVisibleItem
        Constant.cellSize.height = Constant.cellSize.width * Constant.collectionItemSizeRate
        castCollectionView.heightAnchor.constraint(
            greaterThanOrEqualToConstant: Constant.cellSize.height).isActive = true
        Constant.genreButtonSize.width = Constant.cellSize.width
    }

    @IBAction func didTapTrailerButton(_ sender: UIButton) {
        self.showHUD(progressLabel: Message.loading)
        presenter.getMovieWithTrailerPath(movieID: movie.movieID)
    }

    @IBAction func didTapSeeMoreButton(_ sender: Any) {
        if overviewLabel.numberOfLines == 0 {
            overviewLabel.numberOfLines = Constant.numLineLabel
            overviewLabel.lineBreakMode = .byTruncatingTail
            seeMoreButton.setTitle(GeneralName.seeMoreTitle, for: .normal)
        } else {
            overviewLabel.numberOfLines = 0
            overviewLabel.lineBreakMode = .byWordWrapping
            seeMoreButton.setTitle(GeneralName.seeLessTitle, for: .normal)
        }
        UIView.animate(withDuration: Constant.durationAnimationTime) {
            self.view.layoutIfNeeded()
        }
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
        overviewLabel.text = movie.overview
        movieName.text = movie.title
    }
}

extension MovieDetailViewController: UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.castCollectionView:
            return self.cast?.count ?? 0
        case self.genresCollectionView:
            return self.movie.genreIDs?.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.castCollectionView:
            let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CastCell",
                                                              for: indexPath) as? CastCell
            if let cell = cell {
                let person = cast[indexPath.row]
                cell.delegate = self
                cell.configPersonItem(person: person, contentView: cell.contentView)
                return cell
            }
        case self.genresCollectionView:
            let cell = genresCollectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell",
                                                                for: indexPath) as? GenreCollectionViewCell
            if let cell = cell, let genreID = movie.genreIDs?[indexPath.row], let genre = Genre(rawValue: genreID) {
                let buttonTitle = String(describing: genre).capitalized
                cell.genreButton.setTitle(buttonTitle, for: .normal)
                cell.delegate = self
                cell.addTo(contentView: cell.contentView)
                cell.genreID = genreID
                return cell
            }
        default:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.castCollectionView:
            return Constant.cellSize
        case self.genresCollectionView:
            return Constant.genreButtonSize
        default:
            return CGSize()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.collectionItemSpacing
    }
}

extension MovieDetailViewController: GenreCollectionViewCellDelegate {
    func didTapGenreButton(genreID: Int) {
        self.showHUD(progressLabel: Message.loading)
        presenter.loadGenreMovies(genreID: genreID)
    }
}

extension MovieDetailViewController: PersonItemDelegate {
    func didTapPersonItem(person: Person) {
        self.showHUD(progressLabel: Message.loading)
        self.presenter.getPerson(personID: person.personID)
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

    func getDataFailure() {
        self.showMessage(title: GeneralName.appName, message: Message.loadDataFailure)
    }

    func getMovieWithTrailerPathSuccess(movie: Movie) {
        self.movie = movie
        guard let trailerPath = movie.trailerPath else {
            self.showMessage(title: GeneralName.appName, message: Message.noTrailerMessage)
            self.dismissHUD(isAnimated: true)
            return
        }
        let trailerViewController = TrailerViewController(nibName: "TrailerViewController", bundle: nil)
        trailerViewController.videoYoutubeID = trailerPath
        trailerViewController.navigationItem.title = GeneralName.trailerLabel
        navigationController?.pushViewController(trailerViewController, animated: true)
        self.dismissHUD(isAnimated: true)
    }

    func navigateToPersonDetail(person: Person) {
        let personDetailViewController = PersonDetailViewController(nibName: "PersonDetailViewController", bundle: nil)
        personDetailViewController.person = person
        navigationController?.pushViewController(personDetailViewController, animated: true)
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
}
