//
//  DetailsViewModel.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation
import UIKit

protocol DetailsViewModelling {
    func getSynopsis()
    func getReviews()
    func getCredits()
    func getSimilarMovies()
    var sections: Box<[DetailsSection]> { get set }
}

class DetailsViewModel: DetailsViewModelling {
    var sections: Box<[DetailsSection]> = Box([])
    private var networkManager: SourceManager
    private var movieId: Int
    
    init(networkManager: SourceManager, movieId: Int) {
        self.networkManager = networkManager
        self.movieId = movieId
    }
    
    func getSynopsis() {
        networkManager.getSynopsis(id: movieId) { synopsis, error in
            guard let synopsis = synopsis else { return }
            let newSection = DetailsSection()
            newSection.synopsis = [synopsis]
            newSection.sectionType = .moviedetails
            self.sections.value.insert(newSection, at: 0)
        }
    }
    
    func getReviews() {
        networkManager.getReviews(id: movieId) { (reviews, error) in
            
        }
    }
    
    func getCredits() {
        networkManager.getCredits(id: movieId) { (credits, error) in
            
        }
    }
    
    func getSimilarMovies() {
        networkManager.getSimilarMovies(id: movieId) { (similarMovies, error) in
            guard let similarMovies = similarMovies else { return }
            let newSection = DetailsSection()
            newSection.sectionType = .similarMovies
            newSection.similarMovies = similarMovies
            self.sections.value.append(newSection)
        }
    }
}
