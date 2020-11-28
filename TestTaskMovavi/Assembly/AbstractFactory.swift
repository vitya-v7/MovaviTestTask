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
		presenter.listAPIService = imageApiService
		return view
	}
	
	class func createImageDetailModule(id: Int) -> UIViewController {
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let view = storyboard.instantiateViewController(identifier: "ImageDetailViewIdentifier") as! ImageDetailView
		
		let presenter = ImageDetailPresenter()
		view.output = presenter
		presenter.view = view
		presenter.imageID = id
		
		let detailApiService = ImageDetailApiService.init()
		detailApiService.apiService = APIService.shared
		presenter.detailAPIService = detailApiService
		return view
	}
}
