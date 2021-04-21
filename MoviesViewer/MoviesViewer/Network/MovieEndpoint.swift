//
//  MovieEndpoint.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation
enum NetworkEnvironment {
    case production
    case staging
}

public enum MovieApi {
    case newMovies(page:Int)
    case synopsis(id: Int)
    case reviews(id: Int)
    case credits(id: Int)
    case similarMovies(id: Int)
}

extension MovieApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.themoviedb.org/3/movie/"
        case .staging: return "https://api.themoviedb.org/3/movie/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .newMovies:
            return "now_playing"
        case .reviews(let id):
            return "\(id)/reviews"
        case .credits(let id):
            return "\(id)/credits"
        case .similarMovies(let id):
            return "\(id)/similar"
        case .synopsis(let id):
            return "\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .newMovies(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":page,
                                                      "language":"en-US",
                                                      "api_key":NetworkManager.MovieAPIKey])
        case .synopsis:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key":NetworkManager.MovieAPIKey])
            
        case .reviews:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key":NetworkManager.MovieAPIKey])
        case .credits:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":1,
                                                      "language":"en-US",
                                                      "api_key":NetworkManager.MovieAPIKey])
        case .similarMovies:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":1,
                                                      "language":"en-US",
                                                      "api_key":NetworkManager.MovieAPIKey])

        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
