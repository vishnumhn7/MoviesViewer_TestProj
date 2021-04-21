//
//  MoviesApiResponseModel.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation
struct MoviesApiResponseModel : Codable {
	let dates : MovieDates?
	let page : Int?
	let results : [Movie]?
	let total_pages : Int?
	let total_results : Int?

	enum CodingKeys: String, CodingKey {

		case dates = "dates"
		case page = "page"
		case results = "results"
		case total_pages = "total_pages"
		case total_results = "total_results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dates = try values.decodeIfPresent(MovieDates.self, forKey: .dates)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		results = try values.decodeIfPresent([Movie].self, forKey: .results)
		total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
		total_results = try values.decodeIfPresent(Int.self, forKey: .total_results)
	}

}
