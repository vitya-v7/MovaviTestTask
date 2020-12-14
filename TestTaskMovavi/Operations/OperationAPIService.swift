//
//  OperationAPIService.swift
//  TestTaskMovavi
//
//  Created by Admin on 12.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

class OperationImageAPIService {


	var pendingOperations = PendingOperations()
	var imageURL: URL?
	var image: UIImage?
	init() {

	}
	
	func startOperations(for photoRecord: NewsElementViewModel, at indexPath: IndexPath, successCallback: @escaping (UIImage?)  ->()) -> () {
		switch (photoRecord.mode) {
		case .none:
			return
		case .normal:
			startDownload(for: photoRecord, at: indexPath, successCallback: successCallback)
		case .sepia:
			startFiltrationSepia(for: photoRecord, at: indexPath, successCallback: successCallback)
		default:
			NSLog("do nothing")
		}
	}


	func startDownload(for photoRecord: NewsElementViewModel, at indexPath: IndexPath, successCallback: @escaping (UIImage?)  ->()) -> () {

		guard pendingOperations.downloadsInProgress[indexPath] == nil else {
			return
		}

		let downloader = ImageDownloader(photoRecord)

		downloader.completionBlock = {
			if downloader.isCancelled {
				return
			}
		}

		DispatchQueue.main.async {
			self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
			//self.tableView?.reloadRows(at: [indexPath], with: .fade)
		}

		pendingOperations.downloadsInProgress[indexPath] = downloader

		pendingOperations.downloadQueue.addOperation(downloader)

		pendingOperations.downloadQueue.waitUntilAllOperationsAreFinished()

		if let image = downloader.image {
			self.image = image
			successCallback(image)
		}
		else {
			assertionFailure("Image didn't load")
		}
	}



	func startFiltrationSepia(for photoRecord: NewsElementViewModel, at indexPath: IndexPath, successCallback: @escaping (UIImage?)  ->()) -> () {
		guard pendingOperations.filtrationsInProgress[indexPath] == nil else {
			return
		}
		guard let imageIn = self.image else { return }
		let filterer = ImageFiltration(photoRecord)
		filterer.completionBlock = {
			if filterer.isCancelled {
				return
			}

			DispatchQueue.main.async {
				self.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
				//self.tableView?.reloadRows(at: [indexPath], with: .fade
			}
		}

		pendingOperations.filtrationsInProgress[indexPath] = filterer
		pendingOperations.filtrationQueue.addOperation(filterer)

		pendingOperations.filtrationQueue.waitUntilAllOperationsAreFinished()

		successCallback(imageIn)
	}


	

}
