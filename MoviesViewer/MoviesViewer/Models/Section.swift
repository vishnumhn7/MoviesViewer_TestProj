//
//  Section.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import UIKit

class Section: Hashable {
    enum SectionType: Int {
        case search
        case movie
        case none
    }
    var id = UUID()
    var title: String
    var videos: [Movie]
    var sectionType : SectionType
    
    init(title: String, videos: [Movie], type:SectionType) {
        self.title = title
        self.videos = videos
        self.sectionType = type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}
