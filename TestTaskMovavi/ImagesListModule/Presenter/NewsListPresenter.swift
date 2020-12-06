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
	@atomic var newsViewModels: [ViewModelInterface]?
	var currentPage = 0
	var limit = Constants.newsPerPage
	var listFulfilled = false
    var spinnerCellIndex: Int = 0
    
    private let lock = NSLock()

	init () {}

	func viewDidLoadDone() {
		newsViewModels = [ViewModelInterface]()
		reloadNews()
		view?.setInitialState()
	}

    func cellWillShow(index: Int) {
        if index == self.spinnerCellIndex {
            self.loadNextPage()
        }
    }

    func reloadNews() {
        listFulfilled = false
		newsAPIService?.getNews(page: currentPage, limit: limit, successCallback: { [weak self] (data:[NewsElementModel]) -> ()  in
			guard let strongSelf = self else {
				return
			}
            strongSelf.currentPage = 0
            strongSelf.setModelsAndReload(models: data)
		}, errorCallback: { (error: Error) in

		})

	}

    func loadNextPage() {
        if listFulfilled {
            return
        }

        let nextPage: Int = self.currentPage + 1
        newsAPIService?.getNews(page: currentPage, limit: limit, successCallback: { [weak self] (data:[NewsElementModel]) -> ()  in
            guard let strongSelf = self else {
                return
            }

            if data.count < strongSelf.limit {
                strongSelf.listFulfilled = true
            }
            strongSelf.currentPage = nextPage
            strongSelf.addModelsAndReload(models: data)
        }, errorCallback: { (error: Error) in

        })
    }

    func setModelsAndReload(models:[NewsElementModel]) {
        if models.count < limit {
            listFulfilled = true
        }

        var resultViewModels: [ViewModelInterface] = generateViewModels(models: models)
        if !listFulfilled {
            spinnerCellIndex = resultViewModels.count
            resultViewModels.append(IndicatorViewModel())
        } else {
            spinnerCellIndex = -1
        }
        DispatchQueue.main.async {
            self.view?.setViewModels(viewModels: resultViewModels)
        }
    }

    func addModelsAndReload(models:[NewsElementModel]) {
        if var localViewModels = newsViewModels {
            localViewModels.append(contentsOf: generateViewModels(models: models))
            newsViewModels = localViewModels
        } else {
            newsViewModels = generateViewModels(models: models)
        }

        var resultViewModels: [ViewModelInterface] = [ViewModelInterface]()
        if !listFulfilled {
            spinnerCellIndex = newsViewModels!.count
            resultViewModels = newsViewModels!
            resultViewModels.append(IndicatorViewModel())
        } else {
            resultViewModels = newsViewModels!
            spinnerCellIndex = -1
        }

        DispatchQueue.main.async {
            self.view?.setViewModels(viewModels: resultViewModels)
        }
    }

    func generateViewModels(models: [NewsElementModel]) -> [ViewModelInterface] {
        var resultArray: [ViewModelInterface] = [ViewModelInterface]()
        for model in models {
            let viewModel = NewsElementViewModel.init(withElementModel: model)
            resultArray.append(viewModel)
        }
        return resultArray
    }
}
