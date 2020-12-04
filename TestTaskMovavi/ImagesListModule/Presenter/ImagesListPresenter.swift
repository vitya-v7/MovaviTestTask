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
	var newsCells: [NewsElementViewModel]?

	init () {}

	func viewDidLoadDone() {
		newsCells = [NewsElementViewModel]()
		loadNews()
		view?.setInitialState()
	}

	func loadNews() {
		xmlParserService?.getNews(successCallback: { [weak self] (data:[Post]) -> ()  in
			guard let strongSelf = self else {
				return
			}
			
			for model in data {
				let viewModel = NewsElementViewModel.init(withElementModel: model)
				strongSelf.newsCells?.append(viewModel)
			}

			DispatchQueue.main.async {
				strongSelf.view!.setViewModel(viewModels:strongSelf.newsCells!)
			}
		}, errorCallback: { (error: Error) in

		})

	}
}

