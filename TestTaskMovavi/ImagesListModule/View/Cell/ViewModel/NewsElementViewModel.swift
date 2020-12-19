//
//  NewsElementViewModel.swift
//  TestTaskMovavi
//
//  Created by Admin. on 04.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

enum ImageState {
	case none
	case normal
	case sepia
	case blackAndWhite
}

class NewsElementViewModel: ViewModelInterface, ImageViewModelInterface {
	
	var title: String
	var imageURL: String
	var mode: ImageState
	
	init (withElementModel model: NewsElementModel) {
		self.title = model.title
		self.imageURL = model.url
		self.mode = .normal
	}
	
	func cellIdentifier() -> String {
		return "NewsElementCellIdentifier"
	}
}


