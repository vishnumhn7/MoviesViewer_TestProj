//
//  FileManager+Extension.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation

public extension FileManager {
// Returns a URL that points to the document folder of this playground.
    static var applicationSupportDirectory: URL {
        return try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
}
