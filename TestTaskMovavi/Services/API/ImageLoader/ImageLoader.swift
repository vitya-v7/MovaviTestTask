//
//  ImageLoader.swift
//  TestTaskSibers
//
//  Created by Viktor D. on 17.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class ImageLoader {
	static var shared: ImageLoader = {
		let instance = ImageLoader()
		return instance
	}()
	
	private init() {}
	
	func loadImage(from urlString: String, successCallback: @escaping (_ data: Data?, _ urlString: String?) -> ()) {
		let session = URLSession.shared
		let url = URL(string: urlString)
		let dataTask = session.dataTask(with: url!) { (data, response, error) in
			if error != nil {
				print("error")
				successCallback(nil, nil)
			} else {
				successCallback(data, urlString)
			}
		}
		dataTask.resume()
	}
}
