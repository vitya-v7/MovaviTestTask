//
//  ImageDownloaderOperation.swift
//  TestTaskMovavi
//
//  Created by Admin on 06.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader: Operation {

	let newsViewModel: NewsElementViewModel
	var image: UIImage?
	init(_ newsViewModel: NewsElementViewModel) {
		self.newsViewModel = newsViewModel
	}

	override func main() {

		if isCancelled {
			return
		}
		var imageData: Data?
		if let url = URL(string: newsViewModel.imageURL) {
			imageData = try? Data(contentsOf: url)
		}
		if isCancelled {
			return
		}

		if let imageData = imageData, !imageData.isEmpty {
			image = UIImage(data:imageData)
		}
	}
}
