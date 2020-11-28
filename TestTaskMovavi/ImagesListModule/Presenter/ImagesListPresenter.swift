//
//  ImagesListPresenter.swift
//  TestTask
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class ImagesListPresenter: ImagesListViewOutput {
	var listAPIService: ImagesListApiInterface?
	var view: ImagesListViewInput?
	var imagesCells: [ImagesElementViewModel]?

	init () {}

	func viewDidLoadDone() {
		view?.setInitialState()
	}

	func cellWithIndexSelected(index: Int) {
		if imagesCells?[index].id != nil {
			self.view?.navigationController?.pushViewController(AbstractFactory.createImageDetailModule(id: imagesCells![index].id!), animated: true)
		}
	}

	func loadImages(text: String) {
		self.view!.showLoading(show: true)
		listAPIService?.getImages(text: text,
								  successCallback: { [weak self] (data:[ImagesElementModel]) -> ()  in
									guard let strongSelf = self else {
										return
									}
									strongSelf.imagesCells = [ImagesElementViewModel]()
									for model in data {
										let viewModel = ImagesElementViewModel.init(withElementModel: model)
										strongSelf.imagesCells?.append(viewModel)
									}

									DispatchQueue.main.async {
										strongSelf.view!.showLoading(show: false)
										strongSelf.view!.setViewModel(viewModels:strongSelf.imagesCells!)
									}
								  }, errorCallback: { (error: Error) in
									DispatchQueue.main.async {
										self.view!.showLoading(show: false)
									}
									print(error)
								})
	}
}
