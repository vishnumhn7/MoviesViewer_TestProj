//
//  TableViewSection.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 21/04/21.
//

import UIKit

class DetailsSection: Hashable {
    enum SectionType: Int {
        case moviedetails
        case similarMovies
    }
    
    var id = UUID()
    var sectionType:SectionType?
    var synopsis: [Synopsis]?
    var similarMovies: [SimilarMovieResults]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DetailsSection, rhs: DetailsSection) -> Bool {
        lhs.id == rhs.id
    }
}
