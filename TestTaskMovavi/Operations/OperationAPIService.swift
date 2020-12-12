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


	let pendingOperations = PendingOperations()
	let imageURL: URL
	var image: UIImage?
	init(imageURL: URL) {
		self.imageURL = imageURL
	}
	
	func startOperations(for photoRecord: NewsElementViewModel, at indexPath: IndexPath, successCallback: @escaping (UIImage?)  ->()) -> () {
		switch (photoRecord.state) {
		case .notDownloaded:
			return
		case .normal:
			startDownload(for: photoRecord, at: indexPath, successCallback: successCallback)
		case .sepia:
			startFiltration(for: photoRecord, at: indexPath, successCallback: successCallback)
		default:
			NSLog("do nothing")
		}
	}


	func startDownload(for photoRecord: NewsElementViewModel, at indexPath: IndexPath, successCallback: @escaping (UIImage?)  ->()) -> () {
		//1
		guard pendingOperations.downloadsInProgress[indexPath] == nil else {
			return
		}

		//2
		let downloader = ImageDownloader(imageURL)

		downloader.completionBlock = {
			if downloader.isCancelled {
				return
			}
		}

		DispatchQueue.main.async {
			self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
			//self.tableView?.reloadRows(at: [indexPath], with: .fade)
		}


		//4
		pendingOperations.downloadsInProgress[indexPath] = downloader

		//5
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



	func startFiltration(for photoRecord: NewsElementViewModel, at indexPath: IndexPath, successCallback: @escaping (UIImage?)  ->()) -> () {
		guard pendingOperations.filtrationsInProgress[indexPath] == nil else {
			return
		}
		guard let imageIn = self.image else { return }
		let filterer = ImageFiltration(imageIn)
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


	func suspendAllOperations() {
		pendingOperations.downloadQueue.isSuspended = true
		pendingOperations.filtrationQueue.isSuspended = true
	}

	func resumeAllOperations() {
		pendingOperations.downloadQueue.isSuspended = false
		pendingOperations.filtrationQueue.isSuspended = false
	}

}
