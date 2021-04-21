//
//  MovieListCoordinator.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation
import UIKit

class MovieListCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let viewModel: ViewModelling
    private var movieListViewController: ViewController!
    private var movieDetailsCordinator: MovieDetailsCoordinator!
    
    init(presenter: UINavigationController, viewModel: ViewModelling) {
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func start() {
        let movieListViewController = ViewController(nibName: "ViewController", bundle: nil)
        movieListViewController.title = "Movies"
        movieListViewController.viewModel = viewModel
        movieListViewController.delegate = self
        presenter.pushViewController(movieListViewController, animated: true)
        self.movieListViewController = movieListViewController
    }
}

class MovieDetailsCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let viewModel: DetailsViewModelling
    private var movieDetailsViewController: DetailsViewController!
    
    init(presenter: UINavigationController, viewModel: DetailsViewModelling) {
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func start() {
        let movieDetailsViewController = DetailsViewController(nibName: nil, bundle: nil)
        movieDetailsViewController.viewModel = viewModel
        presenter.pushViewController(movieDetailsViewController, animated: true)
        self.movieDetailsViewController = movieDetailsViewController
    }
}


extension MovieListCoordinator: movieListViewControllerDelegate {
    func viewControllerDidSelectMovie(_ selectedMovie: Movie) {
        let movieDetailCoordinator = MovieDetailsCoordinator(presenter: presenter, viewModel: DetailsViewModel(networkManager: NetworkManager(), movieId: selectedMovie.id ?? 0))
        movieDetailCoordinator.start()
        self.movieDetailsCordinator = movieDetailCoordinator
    }
}

protocol movieListViewControllerDelegate: class {
    func viewControllerDidSelectMovie(_ selectedMovie: Movie)
}

