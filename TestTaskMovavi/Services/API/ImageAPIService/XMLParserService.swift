//
//  XMLParserService.swift
//  TestTaskMovavi
//
//  Created by Admin on 03.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class XMLParserService: NSObject, XMLParserDelegate {
	
	struct Post {
		public var title: String!
		public var url: String!
	}

	override init() {
		super.init()

		tempPost = Post(title:"Lenta RSS")
	}

	var posts:[Post] = []
	var parser = XMLParser()
	var tempPost: Post? = nil
	var tempElement: String?

	var apiService: APIService? = nil
	var delegate: XMLParserService?
	func getNews(successCallback: @escaping ([ImagesElementModel]) -> (), errorCallback: @escaping (Error) -> ()) {
		apiService!.getRequest(path: APIService.shared.host, successCallback: { (data: Data?) in
			do {
				self.parser = XMLParser.init(data: data!)
				self.parser.delegate = self
				self.parser.parse()
				let data2 = data
				//let pictures: ImagesContainerModel = try decoder.decode(ImagesContainerModel.self, from: data!)
				//successCallback(pictures.images)
			}
			catch {
				print(error)
			}
		}, errorCallback: errorCallback)
	}


	//MARK: - XMLParserDelegate
	private func parser(parser: XMLParser, parseErrorOccurred parseError: NSError) {
		print("parse error: \(parseError)")
	}
	var urlImage: String?
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?, attributes: [String : String]) {
		tempElement = elementName
		if elementName == "item" {
			tempPost = Post(title: "", url: "")
		}
		if elementName == "enclosure" {
			if let urlString = attributes["url"] {
				tempPost?.url = urlString
			}
		}
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName: String?) {
		if elementName == "item" {
			if let post = tempPost {
				posts.append(post)
			}

			tempPost = nil
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if let post = tempPost {
			if tempElement == "title" {
				tempPost?.title = post.title+string
			}
		}
	}
}
