//
//  ImagesElementCell.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 17.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class ImagesElementCell: UITableViewCell {
	
	@IBOutlet weak var smallImage: UIImageView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var detail: UILabel!
	
	var viewModel: ImagesElementViewModel?
	static let reuseIdentifier = "ImagesListCellIdentifier"
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func prepareForReuse() {
		self.smallImage.backgroundColor = UIColor.lightGray
		self.smallImage.image = nil
	}
	
	func configureCell(withObject object: ImagesElementViewModel) {
		viewModel = object
		setImageToImageView(urlString: object.imageURL!)
		self.title!.text = "User: " + object.user!
		self.detail!.text = "Views: " + String(object.views!)
	}
	
	func setImageToImageView(urlString: String) {
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
				}
			} else {
				strongSelf.smallImage.image = nil
				print("Error loading image");
			}
		}
	}
}
