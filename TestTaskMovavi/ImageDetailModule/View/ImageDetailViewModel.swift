//
//  ImageDetailViewModel.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 18.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class ImageDetailViewModel {
	var imageURL: String
	var width: String
	var height: String
	
	init () {
		self.imageURL = ""
		self.width = ""
		self.height = ""
	}
	
	init (detailModel:ImageDetailModel) {
		self.imageURL = detailModel.imageURL
		self.width = String(detailModel.width)
		self.height = String(detailModel.height)
	}
}
