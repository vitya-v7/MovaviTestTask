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
		else {
			DispatchQueue.main.async {
				self.newsViewModel?.removeLast()
				DispatchQueue.main.async { [weak self] in
					guard let strongSelf = self else {
						return
					}
					if let newsViewModel = strongSelf.newsViewModel {
						strongSelf.view!.setViewModel(viewModels: newsViewModel)
					}
				}
			}
		}
	}

	func loadNews() {
		newsAPIService?.getNews(page: currentPage, limit: limit, successCallback: { [weak self] (data:[NewsElementModel]?) -> ()  in
			var countLoadedNews = 0
			guard let strongSelf = self else {
				return
			}

			if strongSelf.firstLoad == false {
				strongSelf.newsViewModel?.removeLast()
				DispatchQueue.main.async {
					strongSelf.view?.removeLastViewModel()
				}
			}
			strongSelf.firstLoad = false

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

			if strongSelf.listFulfilled == false {
				let indicatorModel = IndicatorViewModel()
				strongSelf.newsViewModel?.append(indicatorModel)
				
			}

			DispatchQueue.main.async {
				if let newsViewModel = strongSelf.newsViewModel {
					
					strongSelf.view!.setViewModel(viewModels: newsViewModel)
				}
			}
		}, errorCallback: { (error: Error) in

		})

	}
}

