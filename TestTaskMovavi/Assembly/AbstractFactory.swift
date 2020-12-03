//
//  AbstractFactory.swift
//  TestTask
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class AbstractFactory {
	class func createImagesListModule() -> UIViewController {
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let view = storyboard.instantiateViewController(identifier: "ImagesListViewIdentifier") as! ImagesListView
		
		let presenter = ImagesListPresenter()
		view.output = presenter
		presenter.view = view
		
		let imageApiService = ImagesApiService.init()
		imageApiService.apiService = APIService.shared

		let xmlParserService = XMLParserService.init()
		xmlParserService.apiService = APIService.shared

		presenter.xmlParserService = xmlParserService

		return view
	}
}
