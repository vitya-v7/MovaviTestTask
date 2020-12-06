//
//  ImageFiltrationOperation.swift
//  TestTaskMovavi
//
//  Created by Admin on 06.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

class ImageFiltration: Operation {
	let photoRecord: PhotoRecord

	init(_ photoRecord: PhotoRecord) {
		self.photoRecord = photoRecord
	}

	override func main () {
		if isCancelled {
			return
		}

		guard self.photoRecord.state == .downloaded else {
			return
		}

		if let image = photoRecord.image,
		   let filteredImage = applySepiaFilter(image) {
			photoRecord.image = filteredImage
			photoRecord.state = .filtered
		}
	}

	func applySepiaFilter(_ image: UIImage) -> UIImage? {
		guard let data = image.pngData() else { return nil }
		let inputImage = CIImage(data: data)

		if isCancelled {
			return nil
		}

		let context = CIContext(options: nil)

		guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
		filter.setValue(inputImage, forKey: kCIInputImageKey)
		filter.setValue(0.8, forKey: "inputIntensity")

		if isCancelled {
			return nil
		}

		guard
			let outputImage = filter.outputImage,
			let outImage = context.createCGImage(outputImage, from: outputImage.extent)
		else {
			return nil
		}

		return UIImage(cgImage: outImage)
	}

}
