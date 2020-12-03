//
//  ImagesListPresenter.swift
//  TestTask
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class ImagesListPresenter: ImagesListViewOutput {

	var xmlParserService: XMLParserService?
	var view: ImagesListViewInput?
	var imagesCells: [Post]?

	init () {}

	func viewDidLoadDone() {
		loadNews()
		view?.setInitialState()
	}

	func loadNews() {
		self.view!.showLoading(show: true)
		xmlParserService?.getNews(successCallback: { [weak self] (data:[Post]) -> ()  in
			guard let strongSelf = self else {
				return
			}
			strongSelf.imagesCells = [Post]()
			for model in data {
				let viewModel = NewsElementViewModel.init(withElementModel: model)
				strongSelf.imagesCells?.append(viewModel)
			}

			DispatchQueue.main.async {
				strongSelf.view!.showLoading(show: false)
				strongSelf.view!.setViewModel(viewModels:strongSelf.imagesCells!)
			}
		}, errorCallback: { (error: Error) in
			DispatchQueue.main.async {
				self.view!.showLoading(show: false)
			}
		})

	}
}

