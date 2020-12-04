//
//  NewsElementViewModel.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class NewsElementViewModel {
	var title: String?
	var imageURL: String?

	init (withElementModel model: NewsElementModel) {
		self.title = model.title
		self.imageURL = model.url
	}
}
