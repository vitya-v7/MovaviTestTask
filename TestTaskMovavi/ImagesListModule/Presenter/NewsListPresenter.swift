//
//  NewsListPresenter.swift
//  TestTask
//
//  Created by Admin. on 04.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class NewsListPresenter: NewsListViewOutput {
	
	var newsAPIService: NewsAPIService?
	var view: NewsListViewInput?
	var newsViewModels: [ViewModelInterface]?
	var currentPage = 0
	var limit = Constants.newsPerPage
	var listFulfilled = false
	var firstLoad = true
	var currentMode:ImageState = .normal

	init () {}

	func viewDidLoadDone() {
		newsViewModels = [ViewModelInterface]()
		loadNews()
		view?.setInitialState()
	}

	func changeModeOfAllViewModels(mode: ImageState) {
		currentMode = mode

		if self.newsViewModels != nil {
			for i in 0 ..< self.newsViewModels!.count {
				if newsViewModels![i] is ImageViewModelInterface {
					var viewModel:ImageViewModelInterface = newsViewModels![i] as! ImageViewModelInterface
					viewModel.mode = mode
				}
			}
		}

		DispatchQueue.main.async { [weak self] in
			guard let strongSelf = self else {
				return
			}
			if let newsViewModel = strongSelf.newsViewModels {
				strongSelf.view!.setViewModel(viewModels: newsViewModel)
			}
		}
	}
	
	func nextPageIndicatorShowed() {
		if listFulfilled == false {
			loadNews()
		}
		else {
			DispatchQueue.main.async {
				self.newsViewModels?.removeLast()
				DispatchQueue.main.async { [weak self] in
					guard let strongSelf = self else {
						return
					}
					if let newsViewModel = strongSelf.newsViewModels {
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
				strongSelf.newsViewModels?.removeLast()
			}
			strongSelf.firstLoad = false

			if let dataIn = data {
				for model in dataIn {
					let viewModel = NewsElementViewModel.init(withElementModel: model)
					countLoadedNews = countLoadedNews + 1
					viewModel.mode = strongSelf.currentMode
					strongSelf.newsViewModels?.append(viewModel)
				}
			}

			if countLoadedNews != strongSelf.limit {
				strongSelf.listFulfilled = true
			}

			strongSelf.currentPage = strongSelf.currentPage + 1

			if strongSelf.listFulfilled == false {
				let indicatorModel = IndicatorViewModel()
				strongSelf.newsViewModels?.append(indicatorModel)
				
			}

			strongSelf.changeModeOfAllViewModels(mode: strongSelf.currentMode)
			
		}, errorCallback: { (error: Error) in
			print(error.localizedDescription)
		})
	}

	func getCurrentMode() -> ImageState {
		return currentMode
	}
}


