//
//  NewsAPIService.swift
//  TestTaskMovavi
//
//  Created by Admin. on 05.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class NewsAPIService {
	var apiService: APIService? = nil
	var xmlParserNews: XMLParserNews?
	
	func getNews(page: Int, limit: Int, successCallback: @escaping ([NewsElementModel]?) -> (), errorCallback: @escaping (Error) -> ()) {
		apiService!.getRequest(path: APIService.shared.host, successCallback: { [weak self] (data: Data?) in
			guard let strongSelf = self else { return }
			strongSelf.xmlParserNews = XMLParserNews()
			if let data = data {
				let news = strongSelf.xmlParserNews?.parseData(data: data, page: page, limit: limit)
				successCallback(news)
			}
			
		}, errorCallback: errorCallback)
	}
}
