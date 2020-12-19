//
//  ImageDownloadOperation.swift
//  TestTaskMovavi
//
//  Created by Admin. on 06.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloadOperation: Operation {

	let imagePath: String
	var image: UIImage?
	init(_ imagePath: String) {
		self.imagePath = imagePath
	}

	override func main() {

		if isCancelled {
			return
		}
		var imageData: Data?
        if let url = URL(string: self.imagePath) {
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
