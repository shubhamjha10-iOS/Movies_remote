//
//  SearchVC.swift
//  Movies
//
//  Created by Shubham Kumar on 31/08/24.
//

import UIKit

class SearchViewController: UIViewController,CoordinatedViewController {
    
    @IBOutlet weak var noResultView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var findItButton: UIButton!
    
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    @IBOutlet weak var bannerBackground: UIView!
    
    @IBOutlet weak var bannerLabel: UILabel!
    
    @IBOutlet weak var bannerSquashConstraint: NSLayoutConstraint!
    
    weak var coordinator: Coordinator?
    var searchCoordinator: SearchCoordinator? {
        return coordinator as? SearchCoordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
       
    }
    
    @IBAction func onTitleEditingDidEnd(_ sender: Any) {
        startSearch()
        
    }
    
    @IBAction func onTappedFindIt(_ sender: Any) {
        titleTextField.resignFirstResponder()
        startSearch()
    }
    
    func startSearch() {
        guard let title = titleTextField.text else {
            return
        }
        searchCoordinator?.performSearch(title: title)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    //    bannerBackground.alpha = 0.0
     //   bannerLabel.alpha = 0.0
    }
    

}

// MARK: - Coordinated Updates

extension SearchViewController {

    func updateSearchResults() {
        resultsCollectionView.reloadData()
       // noResultsView.alpha = 0.0
        resultsCollectionView.alpha = 1.0
    }

    func updateNoMoviesFound() {
        resultsCollectionView.reloadData()
     //   noResultsView.alpha = 1.0
        resultsCollectionView.alpha = 0.0
    }

    // Integrate poster images into the UI as they become available.
    func posterBecameAvailable(imdbId: String, posterImage: UIImage) {
        // Determine if any visible cells need the poster (if not the
        // poster will get picked up when any fresh cell is configured).
        resultsCollectionView.visibleCells.forEach { cell in
            guard
                let movieCell = cell as? MovieCollectionViewCell,
                movieCell.movie?.imdbId == imdbId
            else {
                return
            }

            movieCell.showPoster(image: posterImage)
        }
    }

}
// MARK: - Error Message Display

extension SearchViewController {
    private static let animationDuration = 0.4

    func showErrorMessage(_ message: String) {
        bannerLabel.text = message
        self.bannerSquashConstraint.priority = .defaultLow
        self.bannerBackground.alpha = 1.0

        UIView.animateKeyframes(
            withDuration: SearchViewController.animationDuration,
            delay: 0.0,
            options: .layoutSubviews
        ) {
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 0.5
            ) {
                self.bannerSquashConstraint.priority = .defaultLow
                self.view.layoutIfNeeded()
            }

            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.5
            ) {
                self.bannerLabel.alpha = 1.0
            }
        }
    }

    func hideErrorMessage() {
        UIView.animateKeyframes(
            withDuration: SearchViewController.animationDuration,
            delay: 0.0,
            options: .layoutSubviews
        ) {
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 0.5
            ) {
                self.bannerLabel.alpha = 0.0
            }

            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.5
            ) {
                self.bannerSquashConstraint.priority = .defaultHigh
                self.view.layoutIfNeeded()
                self.bannerBackground.alpha = 0.0
            }
        }
    }

}

// MARK: - Collection View Delegate

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        // Safely unwrap the optional UICollectionViewCell
        guard
            let cell = collectionView.cellForItem(at: indexPath),
            let movieCell = cell as? MovieCollectionViewCell, // Attempt to cast
            let movie = movieCell.movie // Access the movie property
        else {
            return false
        }

        // Proceed with your logic
        searchCoordinator?.showDetailScreen(movie: movie)
        return true
    }

}


// MARK: - Collection View Data Source

extension SearchViewController: UICollectionViewDataSource {

    private static let movieCellIdentifier = "MovieCollectionViewCell"

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return searchCoordinator?.moviesSearchResultCount ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let movie = searchCoordinator?.movieSearchResult(atIndex: indexPath.row),
            let movieCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchViewController.movieCellIdentifier,
                for: indexPath
            ) as? MovieCollectionViewCell
        else {
            fatalError("Failed to dequeue MovieCollectionViewCell or fetch movie.")
        }

        movieCell.configure(movie: movie)

        if let imdbId = movie.imdbId,
           let posterImage = searchCoordinator?.getPosterImage(imdbId: imdbId)
        {
            movieCell.showPoster(image: posterImage)
        } else {
            movieCell.showPoster(image: nil)
        }

        return movieCell
    }

}

// MARK: - Flow Layout Delegate

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    private static let portraitWidth: CGFloat = {
        min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }()

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let twoPer = (0.9 * SearchViewController.portraitWidth) / 2
        if twoPer > 324 {
            return CGSize(width: twoPer, height: 250)
        }

        return CGSize(width: 324, height: 250)
    }

}

// MARK: - Text Field Delegate

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

}
