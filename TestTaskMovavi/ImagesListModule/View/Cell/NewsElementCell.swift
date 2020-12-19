//
//  NewsElementCell.swift
//  TestTaskMovavi
//
//  Created by Admin. on 06.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class NewsElementCell: UITableViewCell {
	
	@IBOutlet weak var smallImage: UIImageView!
	@IBOutlet weak var title: UILabel!
	var imageIn: UIImage?
	var viewModel: NewsElementViewModel?
	var imageService: OperationImageAPIService?
	override func awakeFromNib() {
		super.awakeFromNib()

		self.smallImage.contentMode = .scaleAspectFit
		self.smallImage.backgroundColor = .white
	}
	
	var operationAPIService: OperationImageAPIService?

	override func prepareForReuse() {
		self.smallImage.backgroundColor = UIColor.lightGray
		self.smallImage.image = nil
	}

	func configureCell(withObject object: NewsElementViewModel, indexPath: IndexPath, service: OperationImageAPIService) {
		viewModel = object
		operationAPIService = service
		guard let stringURL = viewModel?.imageURL else { return }
		let urlImage = URL.init(string: stringURL)
		operationAPIService!.imageURL = urlImage
		self.title!.text = object.title

		operationAPIService!.startDownload(imagePath: object.imageURL,
										   indexPath: indexPath,
										   filtrationMode:object.mode,
										   successCallback: { [weak self] (image: UIImage?, imagePath:String) in
											guard let strongSelf = self else {
												return
											}

											var loadedImage:UIImage? = image
											if (self?.viewModel?.imageURL != imagePath) {
												loadedImage = nil
											}

											DispatchQueue.main.async {
												strongSelf.smallImage.image = loadedImage
											}
										   })
	}
}
