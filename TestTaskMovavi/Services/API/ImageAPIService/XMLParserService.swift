//
//  XMLParserService.swift
//  TestTaskMovavi
//
//  Created by Admin on 03.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Post {
	public var title: String!
	public var url: String!
}

class XMLParserService: NSObject, XMLParserDelegate {
	

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
	func getNews(successCallback: @escaping ([Post]) -> (), errorCallback: @escaping (Error) -> ()) {
		apiService!.getRequest(path: APIService.shared.host, successCallback: { [weak self] (data: Data?) in
			guard let strongSelf = self else { return }
			strongSelf.parser = XMLParser.init(data: data!)
			strongSelf.parser.delegate = self
			strongSelf.parser.parse()
			successCallback(strongSelf.posts)
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
