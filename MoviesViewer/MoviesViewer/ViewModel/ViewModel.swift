//
//  ViewModel.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation
import UIKit

protocol ViewModelling {
    var showRecentSearchList: Bool { get set }
    var isSearching: Bool { get set }
    var sections: Box<[Section]> { get set }
    func itemTapped(movie: Movie)
    func updateSearchResults(with query: String, showRecentSearch:Bool)
    func height(sectionIndex: Int) -> CGFloat
    func getNowPlaying(completion: @escaping (_ success: Bool?)->())
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>

class ViewModel: ViewModelling {
    
    var sections: Box<[Section]> = Box([])
    private var networkManager: SourceManager
    var isSearching = false
    var showRecentSearchList = false
    private var networkSections: [Section] = []
    
    init(networkManager: SourceManager) {
        self.networkManager = networkManager
    }
    
    func filteredSections(for queryOrNil: String?, showRecentSearch:Bool) -> [Section] {
        self.showRecentSearchList = showRecentSearch
        isSearching = !(queryOrNil?.isEmpty ?? true)
        let sections = networkSections
        
        if showRecentSearch {
            let recentSearches = retrieveSearchedMovies()
            let sectionTitle = recentSearches.count > 0 ? "Recent Searches" : ""
            return [Section(title: sectionTitle, videos: recentSearches, type: .search)]
        } else {
            let filteredMovies = sections.first!.videos.filter { video in
                return searchLogic(title: video.title?.lowercased() ?? "", query: queryOrNil?.lowercased() ?? "")
            }
            return [Section(title: "Search Result", videos: filteredMovies, type: .movie)]
        }
    }
    
    private func searchLogic(title: String, query: String) -> Bool {
        var searchMatched = false
        
        // checks whether movie name (splitted with space) starts with entire query string
        // Eg : search for "A" in movie name "ABCD EF GH"
        let words = title.split{$0 == " "}.map(String.init)
        searchMatched =  words.contains { (word) -> Bool in
            word.starts(with: query)
        }
        
        guard !searchMatched else {
            return true
        }
        
        let queryWords = query.split{$0 == " "}.map(String.init)
        // checks whether each movie words in movie name (splitted with space) match with each words in query string
        // Eg : search for "EF GH ABCD" in movie name "ABCD EF GH"
        searchMatched = {
            let set1:Set<String> = Set(queryWords)
            let set2:Set<String> = Set(words)
            return set1.subtracting(set2).isEmpty
        }()
        
        guard !searchMatched else {
            return true
        }
        
        // checks with each query words (splitted with space) match with each words in movie name
        // Eg : search for "EF G" in movie name "ABCD EF GH"
        if queryWords.count > 1 {
            var counter = 0
            var firstQueryWordExists = false
            for queryIndex in 0..<queryWords.count {
                guard counter <= words.count else { return searchMatched }
                for index in counter..<words.count {
                    if queryIndex == (queryWords.count - 1) {
                        if firstQueryWordExists && words[index].starts(with: queryWords[queryIndex]) {
                            searchMatched = true
                        }
                    } else {
                        if queryWords[queryIndex] == words[index] {
                            counter = index + 1
                            firstQueryWordExists = true
                            break
                        }
                    }
                }
            }
        }
        
        return searchMatched
    }
    
    private func storeSearched(movies: [Movie]) {
        do {
            let plistURL = URL(fileURLWithPath: "myAPIKeys", relativeTo: FileManager.applicationSupportDirectory).appendingPathExtension("plist")
            
            let plistEncoder = PropertyListEncoder()
            plistEncoder.outputFormat = .xml
            let plistData = try plistEncoder.encode(movies)
            try plistData.write(to: plistURL)
        } catch {print(error) }
        
    }
    
    private func checkIfSearchItemAlreadySaved(movie: Movie) -> Bool {
        let savedMovies = retrieveSearchedMovies()
        for item in savedMovies {
            if movie.id == item.id {
                return true
            }
        }
        return false
    }
    
    private func retrieveSearchedMovies() -> [Movie] {
        let plistURL = URL(fileURLWithPath: "myAPIKeys", relativeTo: FileManager.applicationSupportDirectory).appendingPathExtension("plist")
        do  {
            let plistDecoder = PropertyListDecoder()
            let data = try Data.init(contentsOf: plistURL)
            let value = try plistDecoder.decode([Movie].self, from: data)
            return value
        } catch { print(error)
            return []
        }
    }
    
    func height(sectionIndex: Int) -> CGFloat {
        if self.showRecentSearchList {
            return 30
        }else {
            return 250
        }
    }
    
    func getNowPlaying(completion: @escaping (Bool?) -> ()) {
        self.sections.value.removeAll()
        networkManager.getNewMovies(page: 1) { movies, error in
            guard let movies = movies else { return }
            let newSection = Section(title: "Now Playing", videos: movies, type: .movie)
            self.sections.value.append(newSection)
            self.networkSections.append(newSection)
            completion(true)
        }
    }
        
    func updateSearchResults(with query: String, showRecentSearch:Bool) {
        sections.value = filteredSections(for: query, showRecentSearch: showRecentSearch)
    }
    
    func itemTapped(movie: Movie) {
        if isSearching && !checkIfSearchItemAlreadySaved(movie: movie) {
            var movies = retrieveSearchedMovies()
            if movies.count >= 5 {
                movies.remove(at: 0)
            }
            movies.append(movie)
            storeSearched(movies: movies)
        }
    }
    
}
