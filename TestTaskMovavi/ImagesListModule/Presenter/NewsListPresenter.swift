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
	var newsViewModel: [NewsElementViewModel]?
	var indicatorViewModel: IndicatorViewModel?
	var firstLoad = true
	var previousNewsLoadedCount = 0

	init () {}

	func viewDidLoadDone() {

		newsViewModel = [NewsElementViewModel]()
		loadNews()
		view?.setInitialState()
	}

	func nextPageIndicatorShowed() {
		if indicatorViewModel == nil {
			indicatorViewModel = IndicatorViewModel()
			loadNews()
		}
	}

	func loadNews() {
		xmlParserService?.getNews(successCallback: { [weak self] (data:[NewsElementModel]) -> ()  in
			guard let strongSelf = self else {
				return
			}
			if let newsViewModel = strongSelf.newsViewModel {
				strongSelf.previousNewsLoadedCount = newsViewModel.count
			}

			for model in data {
				let viewModel = NewsElementViewModel.init(withElementModel: model)
				strongSelf.newsViewModel?.append(viewModel)
			}

			DispatchQueue.main.async {
				if let newsViewModel = strongSelf.newsViewModel {
					strongSelf.view!.setViewModel(viewModels: newsViewModel)
					if strongSelf.firstLoad == false {
						strongSelf.view!.deleteRows(at: [IndexPath.init(row: strongSelf.previousNewsLoadedCount, section: 0)])
					}
					strongSelf.indicatorViewModel = nil
					strongSelf.firstLoad = false
				}
			}
		}, errorCallback: { (error: Error) in

		})

	}
}

