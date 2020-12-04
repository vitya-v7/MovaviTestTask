//
//  NewsListPresenter.swift
//  TestTask
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class NewsListPresenter: NewsListViewOutput {

	var xmlParserService: XMLParserService?
	var view: NewsListViewInput?
	var newsCells: [NewsElementViewModel]?
	var indicatorModel: IndicatorViewModel?

	init () {}

	func viewDidLoadDone() {
		newsCells = [NewsElementViewModel]()
		indicatorModel = IndicatorViewModel()
		loadNews()
		view?.setInitialState()
	}

	func nextPageIndicatorShowed() {
		loadNews()
	}

	func loadNews() {
		xmlParserService?.getNews(successCallback: { [weak self] (data:[NewsElementModel]) -> ()  in
			guard let strongSelf = self else {
				return
			}
			strongSelf.newsCells = [NewsElementViewModel]()
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

