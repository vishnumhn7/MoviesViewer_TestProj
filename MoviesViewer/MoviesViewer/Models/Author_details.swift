//
//  Author_details.swift
//  MoviesViewer
//
//  Created by Mohan, Vishnu on 20/04/21.
//

import Foundation
struct Author_details : Codable {
	let name : String?
	let username : String?
	let avatar_path : String?
	let rating : Int?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case username = "username"
		case avatar_path = "avatar_path"
		case rating = "rating"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		avatar_path = try values.decodeIfPresent(String.self, forKey: .avatar_path)
		rating = try values.decodeIfPresent(Int.self, forKey: .rating)
	}

}
