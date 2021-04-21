//
//  ApplicationCoordinator.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    
    let window: UIWindow
    let rootViewController: UINavigationController
    let flickerListCoordinator: MovieListCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        let viewModel = ViewModel(networkManager: NetworkManager())
        flickerListCoordinator = MovieListCoordinator(presenter: rootViewController, viewModel: viewModel)
    }
    
    func start() {
        window.rootViewController = rootViewController
        flickerListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
