//
//  NetworkManager.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation
enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

protocol SourceManager {
    func getNewMovies(page: Int, completion: @escaping (_ movie: [Movie]?,_ error: String?)->())
    func getSynopsis(id: Int, completion: @escaping (_ synopsis: Synopsis?,_ error: String?)->())
    func getReviews(id: Int, completion: @escaping (_ reviews: [ReviewResults]?,_ error: String?)->())
    func getCredits(id: Int, completion: @escaping (_ casts: [Cast]?,_ error: String?)->())
    func getSimilarMovies(id: Int, completion: @escaping (_ casts: [SimilarMovieResults]?,_ error: String?)->())
}

struct NetworkManager: SourceManager {
    
    static let environment : NetworkEnvironment = .production
    static let MovieAPIKey = "22436664e13fa994dac7e48bd5a4bef7"
    let router = Router<MovieApi>()
    
    func getNewMovies(page: Int, completion: @escaping (_ movie: [Movie]?,_ error: String?)->()){
        router.request(.newMovies(page: page)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(MoviesApiResponseModel.self, from: responseData)
                        print(apiResponse)
                        completion(apiResponse.results,nil)
                    }catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getSynopsis(id: Int, completion: @escaping (_ synopsis: Synopsis?,_ error: String?)->()){
        router.request(.synopsis(id: id)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(Synopsis.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getReviews(id: Int, completion: @escaping (_ reviews: [ReviewResults]?,_ error: String?)->()){
        router.request(.reviews(id: id)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(MovieReviews.self, from: responseData)
                        completion(apiResponse.results,nil)
                    }catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getCredits(id: Int, completion: @escaping (_ casts: [Cast]?,_ error: String?)->()){
        router.request(.credits(id: id)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(MoviewCredits.self, from: responseData)
                        completion(apiResponse.cast,nil)
                    }catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (_ casts: [SimilarMovieResults]?,_ error: String?)->()) {
        router.request(.similarMovies(id: id)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(SimilarMovies.self, from: responseData)
                        completion(apiResponse.results,nil)
                    }catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
