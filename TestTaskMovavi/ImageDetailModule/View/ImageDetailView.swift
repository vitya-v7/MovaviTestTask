//
//  ImageDetailView.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 18.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

protocol ImageDetailViewInput : UIViewController  {
	func setInitialState()
	func setViewModel(viewModel: ImageDetailViewModel)
	func showLoading(show: Bool)
}

protocol ImageDetailViewOutput {
	func viewDidLoadDone()
	func loadImage()
}

class ImageDetailView: UIViewController, ImageDetailViewInput {
	var output: ImageDetailViewOutput?
	var viewModel: ImageDetailViewModel?
	
	@IBOutlet weak var bigImage: UIImageView!
	@IBOutlet weak var width: UILabel!
	@IBOutlet weak var height: UILabel!
	@IBOutlet var activityIndicator: UIActivityIndicatorView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		output?.viewDidLoadDone()
	}
	
	func setInitialState() {
		self.bigImage?.backgroundColor = .clear
	}
	
	func showLoading(show: Bool) {
		if show {
			self.activityIndicator?.startAnimating()
		}
		else {
			self.activityIndicator?.stopAnimating()
		}
	}
	
	func setViewModel(viewModel: ImageDetailViewModel) {
		self.viewModel = viewModel
		self.configureDetailView(withObject: viewModel)
	}
	
	private func configureDetailView(withObject object: ImageDetailViewModel) {
		setImageToImageView(urlString: object.imageURL)
		self.width!.text = String("Width: " + object.width)
		self.height!.text = String("Height: " + object.height)
		
	}
	
	private func setImageToImageView(urlString: String) {
		self.showLoading(show: true)
		ImageLoader.shared.loadImage(from: urlString) { [weak self] (imageData, urlString) in
			guard let strongSelf = self else {
				return
			}
			if let data = imageData {
				DispatchQueue.main.async {
					strongSelf.showLoading(show: false)
					strongSelf.bigImage?.image = UIImage(data: data)
				}
			}
		}
	}    
}

