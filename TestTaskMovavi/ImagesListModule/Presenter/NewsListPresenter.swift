//
//  NewsListPresenter.swift
//  TestTask
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class NewsListPresenter: NewsListViewOutput {


	var newsAPIService: NewsAPIService?
	var view: NewsListViewInput?
	var newsViewModel: [AnyObject]?
	var currentPage = 0
	var limit = Constants.newsPerPage
	var listFulfilled = false
	var firstLoad = true

	init () {}

	func viewDidLoadDone() {

		newsViewModel = [AnyObject]()
		loadNews()
		view?.setInitialState()
	}

	func nextPageIndicatorShowed() {
		if listFulfilled == false {
			loadNews()
		}
	}

	func appendViewModel(viewModel: AnyObject) {
		newsViewModel?.append(viewModel)
		self.view?.appendViewModel(viewModel: viewModel)
	}

	func removeLastViewModel() {
		newsViewModel?.removeLast()
		self.view?.removeLastViewModel()
	}

	func loadNews() {
		newsAPIService?.getNews(page: currentPage, limit: limit, successCallback: { [weak self] (data:[NewsElementModel]?) -> ()  in
			var countLoadedNews = 0
			guard let strongSelf = self else {
				return
			}

			DispatchQueue.main.async {
				if strongSelf.firstLoad == false {
					strongSelf.removeLastViewModel()
				}
			}

			if let dataIn = data {
				for model in dataIn {
					let viewModel = NewsElementViewModel.init(withElementModel: model)
					countLoadedNews = countLoadedNews + 1
					strongSelf.newsViewModel?.append(viewModel)
				}
			}

			if countLoadedNews != strongSelf.limit {
				strongSelf.listFulfilled = true
			}

			strongSelf.currentPage = strongSelf.currentPage + 1
			DispatchQueue.main.async {
				if let newsViewModel = strongSelf.newsViewModel {
					strongSelf.view!.setViewModel(viewModels: newsViewModel)
				}
				if strongSelf.listFulfilled == false {
					let indicatorCell = IndicatorViewCell()
					strongSelf.appendViewModel(viewModel: indicatorCell)
				}
			}
		}, errorCallback: { (error: Error) in

		})

	}
}

