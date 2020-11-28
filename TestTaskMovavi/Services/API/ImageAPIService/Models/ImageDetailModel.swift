//
//  ImageDetailModel.swift
//  TestTaskSibers
//
//  Created by Viktor D. on 18.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

struct ImageDetailModelContainer: Codable {
	var images: [ImageDetailModel]
	
	enum HitsKeys: String, CodingKey {
		case images = "hits"
	}
	
	init(from decoder: Decoder) throws  {
		images = [ImageDetailModel]()
		do {
			let values = try decoder.container(keyedBy: HitsKeys.self)
			images = try values.decode([ImageDetailModel].self, forKey: .images)
		}
		catch {
			print(error)
		}
	}
}

struct ImageDetailModel: Codable {
	var width: Int
	var height: Int
	var imageURL: String
	
	enum CodingKeys: String, CodingKey {
		case width = "imageWidth"
		case height = "imageHeight"
		case imageURL = "largeImageURL"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		imageURL = try values.decode(String.self, forKey: .imageURL)
		width = try values.decode(Int.self, forKey: .width)
		height = try values.decode(Int.self, forKey: .height)
	}
}
