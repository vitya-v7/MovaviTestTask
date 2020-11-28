//
//  ImageDetailApiService.swift
//  TestTaskSibers
//
//  Created by Viktor D. on 18.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

protocol ImageDetailApiInterface {
	func createLargeImageLink(id: Int) -> String
	func getImageById(id: Int, successCallback: @escaping (ImageDetailModel) -> (), errorCallback: @escaping (Error) -> ())
}

class ImageDetailApiService: ImageDetailApiInterface {
	var apiService: APIService?
	let path: String = ""
	var imageLink: String?
	
	func createLargeImageLink(id: Int) -> String {
		return apiService!.host + String(id)
	}
	
	func getImageById(id: Int, successCallback: @escaping (ImageDetailModel) -> (), errorCallback: @escaping (Error) -> ()) {
		apiService!.getRequest(path: path, parameters: ["id":String(id)], successCallback: { (data: Data?) in
			do {
				let decoder = JSONDecoder()
				let pictures: ImageDetailModelContainer = try decoder.decode(ImageDetailModelContainer.self, from: data!)
				successCallback(pictures.images.first!)
			}
			catch {
				print(error)
			}
		}, errorCallback: errorCallback)
	}
}
