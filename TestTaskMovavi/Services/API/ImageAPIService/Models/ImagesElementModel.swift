//
//  ImagesElementModel.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

struct ImagesContainerModel: Codable {
	var images: [ImagesElementModel]
	
	enum HitsKeys: String, CodingKey {
		case images = "hits"
	}
	
	init(from decoder: Decoder) throws  {
		images = [ImagesElementModel]()
		do {
			let values = try decoder.container(keyedBy: HitsKeys.self)
			images = try values.decode([ImagesElementModel].self, forKey: .images)
		}
		catch {
			print(error)
		}
	}
}

struct ImagesElementModel: Codable {
	var id: Int
	var imageURL: String
	var user: String
	var views: Int
	
	enum CodingKeys: String, CodingKey {
		case id
		case imageURL = "previewURL"
		case user
		case views
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		imageURL = try values.decode(String.self, forKey: .imageURL)
		user = try values.decode(String.self, forKey: .user)
		views = try values.decode(Int.self, forKey: .views)
	}
}
