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

	let imageURL: URL
	var image: UIImage?
	init(_ imageURL: URL) {
		self.imageURL = imageURL
	}

	override func main() {


		if isCancelled {
			return
		}

		guard let imageData = try? Data(contentsOf: imageURL) else { return }

		if isCancelled {
			return
		}

		if !imageData.isEmpty {
			image = UIImage(data:imageData)
		}
	}
}
