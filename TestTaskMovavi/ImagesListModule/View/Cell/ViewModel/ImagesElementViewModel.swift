//
//  ImagesElementViewModel.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class ImagesElementViewModel {
	var id: Int?
	var imageURL: String?
	var user: String?
	var views: Int?
	
	init (withElementModel model: ImagesElementModel) {
		self.id = model.id
		self.imageURL = model.imageURL
		self.user = model.user
		self.views = model.views
	}
}
