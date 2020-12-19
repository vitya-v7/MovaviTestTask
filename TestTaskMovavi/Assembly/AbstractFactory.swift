//
//  AbstractFactory.swift
//  TestTask
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class AbstractFactory {
	class func createNewsListModule() -> UIViewController {
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let view = storyboard.instantiateViewController(identifier: "NewsListViewIdentifier") as! NewsListView
		let presenter = NewsListPresenter()
		let newsAPIService = NewsAPIService()
		newsAPIService.apiService = APIService.shared
		presenter.newsAPIService = newsAPIService
		let operationAPIService = OperationImageAPIService()
		view.operationAPIService = operationAPIService
		view.output = presenter
		presenter.view = view
		return view
	}
}
