//
//  NewsElementCell.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 17.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
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

		// Initialization code
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
		//setImageToImageView(urlString: object.imageURL!)


		if object.mode != .normal {
			operationAPIService!.startDownload(for: object, at: indexPath, successCallback: { [weak self] (image: UIImage?) in
				guard let strongSelf = self else {
					return
				}
				DispatchQueue.main.async {
					strongSelf.smallImage.contentMode = .scaleAspectFit
					strongSelf.smallImage.backgroundColor = .white
					strongSelf.smallImage.image = image
				}
			})
		}
		if object.mode == .sepia {
			operationAPIService!.startFiltrationSepia(for: object, at: indexPath, successCallback: { [weak self] (image: UIImage?) in
				guard let strongSelf = self else {
					return
				}
				DispatchQueue.main.async {
					strongSelf.smallImage.contentMode = .scaleAspectFit
					strongSelf.smallImage.backgroundColor = .white
					strongSelf.smallImage.image = image
				}
			})
		}
	}



	/*func setImageToImageView(urlString: String) {
		ImageLoader.shared.loadImage(from: urlString) { [weak self] (imageData, urlString) in
			guard let strongSelf = self else {
				return
			}
			if let data = imageData {
				DispatchQueue.main.async {
					if urlString == strongSelf.viewModel?.imageURL {
						strongSelf.smallImage?.image = UIImage(data: data)
					}
					else {
						strongSelf.smallImage.image = nil
					}
					strongSelf.smallImage.contentMode = .scaleAspectFit
					strongSelf.smallImage.backgroundColor = .white
					
				}
			} else {
				strongSelf.smallImage.image = nil
				print("Error loading image");
			}
		}
	}*/
}
