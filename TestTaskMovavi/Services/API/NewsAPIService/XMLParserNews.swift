//
//  XMLParserNews.swift
//  TestTaskMovavi
//
//  Created by Admin on 03.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation



class XMLParserNews: NSObject, XMLParserDelegate {
	
	var page: Int
	var limit: Int
	var currentElement: Int
	var endElement: Int
	var startElement: Int
	var tempNewsElementModel: NewsElementModel? = nil
	var tempElement: String?
	var posts:[NewsElementModel]?

	override init() {
		startElement = 0
		endElement = 0
		currentElement = 0
		self.page = 0
		self.limit = Constants.newsPerPage
		tempNewsElementModel = NewsElementModel(title:"Lenta RSS")
		posts = [NewsElementModel]()
		super.init()
	}

	deinit {
		posts = nil
	}

	func parseData(page: Int, limit: Int) -> [NewsElementModel]? {
		self.page = page
		self.limit = limit
		let xmlParser = XMLParser()
		xmlParser.delegate = self
		endElement = (page + 1) * limit
		startElement = page * limit
		xmlParser.parse()
		return posts
	}

	//MARK: - XMLParserDelegate

	var urlImage: String?
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?, attributes: [String : String]) {
		tempElement = elementName
		if elementName == "item" {
			tempNewsElementModel = NewsElementModel(title: "", url: "")
		}
		if elementName == "enclosure" {
			if let urlString = attributes["url"] {
				tempNewsElementModel?.url = urlString
			}
		}
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName: String?) {
		if elementName == "item" {
			if let post = tempNewsElementModel, currentElement < endElement,
			   currentElement >= startElement {
				posts?.append(post)
			}
			currentElement = currentElement + 1
			tempNewsElementModel = nil
			if currentElement > endElement {
				page = page + 1
				currentElement = 0

				parser.abortParsing()
			}
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if let post = tempNewsElementModel {
			if tempElement == "title" {
				tempNewsElementModel?.title = post.title+string
			}
		}
	}

	func parserDidEndDocument(_ parser: XMLParser) {

	}
}
