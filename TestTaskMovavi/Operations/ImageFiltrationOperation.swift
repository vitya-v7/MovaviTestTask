//
//  ImageFiltrationOperation.swift
//  TestTaskMovavi
//
//  Created by Admin. on 06.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

class ImageFiltration: Operation {

	let originalImage:UIImage!
	var image: UIImage?
	var mode: ImageState?
	init(_ image: UIImage, mode: ImageState) {
		self.originalImage = image
		self.mode = mode
	}

	override func main () {
		if isCancelled {
			return
		}
		
		if self.mode == .sepia {
			let filteredImage = applySepiaFilter(originalImage)
			self.image = filteredImage
		}
		if self.mode == .blackAndWhite {
			let filteredImage = applyBlackWhiteFilter(originalImage)
			self.image = filteredImage
		}

	}

	func applyBlackWhiteFilter(_ image:UIImage) -> UIImage? {
		guard let currentCGImage = image.cgImage else { return nil }

		if isCancelled {
			return nil
		}

		let currentCIImage = CIImage(cgImage: currentCGImage)
		let filter = CIFilter(name: "CIColorMonochrome")
		filter?.setValue(currentCIImage, forKey: "inputImage")
		filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
		filter?.setValue(1.0, forKey: "inputIntensity")

		if isCancelled {
			return nil
		}

		guard let outputImage = filter?.outputImage else { return nil }
		let context = CIContext()
		if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
			let processedImage = UIImage(cgImage: cgimg)
			return processedImage
		}
		return nil
	}

	func applySepiaFilter(_ image: UIImage) -> UIImage? {
		if image.pngData() != nil {
			let inputImage = CIImage(data: image.pngData()!)

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

		return nil
	}
}
