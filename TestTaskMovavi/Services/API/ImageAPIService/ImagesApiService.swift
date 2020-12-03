//
//  ImagesApiService.swift
//  TestTask
//
//  Created by Viktor D. on 15.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

protocol ImagesListApiInterface {
	func getImages(text: String, successCallback: @escaping ([ImagesElementModel]) -> () , errorCallback: @escaping (Error)->())
}

class ImagesApiService: ImagesListApiInterface {

	var apiService: APIService?
	// values hardcode
	let path: String = ""
	let perPage = 50
	
	private func addPerPage(parameters:[String:String]) -> [String:String] {
		var inParameters = parameters
		inParameters.updateValue(String.init(perPage), forKey: "per_page")
		return inParameters
	}
	
	func getImages(text: String, successCallback: @escaping ([ImagesElementModel]) -> (), errorCallback: @escaping (Error) -> ()) {
		let parameters = ["q": replaceSpacesWithPluses(text: text)]
		let inParameters = addPerPage(parameters: parameters)
		apiService!.getRequest(path: path, successCallback: { (data: Data?) in
			do {
				let decoder = JSONDecoder()
				let pictures: ImagesContainerModel = try decoder.decode(ImagesContainerModel.self, from: data!)
				successCallback(pictures.images)
			}
			catch {
				print(error)
			}
		}, errorCallback: errorCallback)
	}
	
	private func replaceSpacesWithPluses(text: String) -> String {
		let words = text.split(separator: " ")
		var result = [String]()
		for word in words {
			result.append(String(word))
		}
		return result.joined(separator: "+")
	}
}

