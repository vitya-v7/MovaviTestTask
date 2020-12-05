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
	init () {}

	func viewDidLoadDone() {

		newsViewModel = [AnyObject]()
		loadNews()
		view?.setInitialState()
	}

	func nextPageIndicatorShowed() {
		if listFulfilled == true {
			newsViewModel?.removeLast()
		}
		else {
			newsViewModel?.append(IndicatorViewCell())
			loadNews()
		}
	}

	func loadNews() {
		newsAPIService?.getNews(page: currentPage + 1, limit: limit, successCallback: { [weak self] (data:[NewsElementModel]?) -> ()  in
			guard let strongSelf = self else {
				return
			}
			var countLoadedNews = 0
			if strongSelf.currentPage > 0 {
				strongSelf.newsViewModel?.removeLast()
			}
			if let dataIn = data {
				for model in dataIn {
					let viewModel = NewsElementViewModel.init(withElementModel: model)
					countLoadedNews = countLoadedNews + 1
					strongSelf.newsViewModel?.append(viewModel)
				}
			}
			strongSelf.currentPage = strongSelf.currentPage + 1
			if countLoadedNews + 1 < strongSelf.limit * strongSelf.currentPage {
				strongSelf.listFulfilled = true
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

