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


	static let pendingOperations = PendingOperations()
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

		guard OperationImageAPIService.pendingOperations.downloadsInProgress[indexPath] == nil else {
			return
		}

		let downloader = ImageDownloader(imageURL)

		downloader.completionBlock = {
			if downloader.isCancelled {
				return
			}
		}

		DispatchQueue.main.async {
			OperationImageAPIService.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
			//self.tableView?.reloadRows(at: [indexPath], with: .fade)
		}

		OperationImageAPIService.pendingOperations.downloadsInProgress[indexPath] = downloader

		OperationImageAPIService.pendingOperations.downloadQueue.addOperation(downloader)

		OperationImageAPIService.pendingOperations.downloadQueue.waitUntilAllOperationsAreFinished()

		if let image = downloader.image {
			self.image = image
			successCallback(image)
		}
		else {
			assertionFailure("Image didn't load")
		}
	}



	func startFiltration(for photoRecord: NewsElementViewModel, at indexPath: IndexPath, successCallback: @escaping (UIImage?)  ->()) -> () {
		guard OperationImageAPIService.pendingOperations.filtrationsInProgress[indexPath] == nil else {
			return
		}
		guard let imageIn = self.image else { return }
		let filterer = ImageFiltration(imageIn)
		filterer.completionBlock = {
			if filterer.isCancelled {
				return
			}

			DispatchQueue.main.async {
				OperationImageAPIService.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
				//self.tableView?.reloadRows(at: [indexPath], with: .fade
			}
		}

		OperationImageAPIService.pendingOperations.filtrationsInProgress[indexPath] = filterer
		OperationImageAPIService.pendingOperations.filtrationQueue.addOperation(filterer)

		OperationImageAPIService.pendingOperations.filtrationQueue.waitUntilAllOperationsAreFinished()

		successCallback(imageIn)
	}


	func suspendAllOperations() {
		OperationImageAPIService.pendingOperations.downloadQueue.isSuspended = true
		OperationImageAPIService.pendingOperations.filtrationQueue.isSuspended = true
	}

	func resumeAllOperations() {
		OperationImageAPIService.pendingOperations.downloadQueue.isSuspended = false
		OperationImageAPIService.pendingOperations.filtrationQueue.isSuspended = false
	}

}
