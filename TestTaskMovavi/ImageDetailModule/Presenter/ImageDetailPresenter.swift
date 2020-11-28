//
//  ImageDetailPresenter.swift
//  TestTaskSibers
//
//  Created by Viktor D. on 18.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class ImageDetailPresenter: ImageDetailViewOutput {
	var imageID: Int?
	var imageLink: String?
	var detailAPIService: ImageDetailApiService?
	var detailViewModel: ImageDetailViewModel?
	var view: ImageDetailViewInput?

	func viewDidLoadDone() {
		view?.setInitialState()
		loadImage()
	}

	func loadImage() {
		detailAPIService?.getImageById(id: imageID!, successCallback: { [weak self] (data:ImageDetailModel) -> ()  in
			guard let strongSelf = self else {
				return
			}
			strongSelf.detailViewModel = ImageDetailViewModel()
			let detailVM = ImageDetailViewModel.init(detailModel: data)
			strongSelf.detailViewModel = detailVM
			DispatchQueue.main.async {
				strongSelf.view!.setViewModel(viewModel:strongSelf.detailViewModel!)
			}
		}, errorCallback: { (error: Error) in
			print(error)
		})
	}
}
