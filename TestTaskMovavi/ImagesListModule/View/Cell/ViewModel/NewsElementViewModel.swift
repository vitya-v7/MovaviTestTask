//
//  NewsElementViewModel.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class NewsElementViewModel: ViewModelInterface {
	var title: String
	var imageURL: String
	var mode: ImageState
	enum ImageState {
		case none
		case normal
		case sepia
		case blackAndWhite
	}
	init (withElementModel model: NewsElementModel) {
		self.title = model.title
		self.imageURL = model.url
		self.mode = .normal
	}

    func cellIdentifier() -> String {
        return "NewsElementCellIdentifier"
    }
}


