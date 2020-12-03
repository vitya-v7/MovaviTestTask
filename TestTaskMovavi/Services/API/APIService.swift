//
//  APIService.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

class APIService {
	//values hardcode
	let APIKey: String = #"17922153-cb6f9085142c570217f7017fe"#
	let host: String = "http://pixabay.com/api"
	
	static var shared: APIService = {
		let instance = APIService()
		return instance
	}()
	
	private init() {
		// Private init because of singleton
	}
	
	func getRequest(path: String, parameters: [String:String], successCallback: @escaping (Data?)  ->(), errorCallback: @escaping (Error)->()) -> () {
		let urlSession = URLSession.shared
		let inParameters = addAPIKey(parameters: parameters)
		let parametersString = createQueryParametersString(parameters: inParameters)
		
		if parametersString != nil, let url = URL(string: host + path + "?" + parametersString!) {
			var urlRequest = URLRequest.init(url: url)
			urlRequest.httpMethod = "GET"
			let dataTask = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
				guard let strongSelf = self else {
					return
				}
				if let error = error {
					errorCallback(error)
				} else {
					if let data = data, let response = response as? HTTPURLResponse {
						
						if strongSelf.isSuccessResponse(response: response) {
							successCallback(data)
						}
					}
				}
			}
			dataTask.resume()
		}
	}
	
	private func addAPIKey(parameters:[String:String]) -> [String:String] {
		var inParameters = parameters
		inParameters.updateValue(String.init(APIKey), forKey: "key")
		return inParameters
	}
	
	private func createQueryParametersString(parameters:  [String:String]) -> String? {
		if parameters.count == 0 {
			return nil
		}
		var result: String = ""
		var index = 0
		for (key, value) in parameters {
			if index > 0 {
				result += "&"
			}
			result += key + "=" + value
			index += 1
		}
		return result
	}
	
	private func isSuccessResponse(response: HTTPURLResponse) -> Bool {
		if response.statusCode >= 200 && response.statusCode <= 299 {
			return true
		}
		return false
	}
}

