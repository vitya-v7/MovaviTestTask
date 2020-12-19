//
//  ImagesOperations.swift
//  TestTaskMovavi
//
//  Created by Admin on 06.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

//MARK: - ManagingOperations

public class PendingOperations {
	lazy var downloadsInProgress: [IndexPath: Operation] = [:]
	lazy var downloadQueue: OperationQueue = {
		var queue = OperationQueue()
		queue.name = "Download queue"
		queue.maxConcurrentOperationCount = 6
		return queue
	}()

	lazy var filtrationsInProgressSepia: [IndexPath: Operation] = [:]
	lazy var filtrationQueueSepia: OperationQueue = {
		var queue = OperationQueue()
		queue.name = "Image Sepia queue"
		queue.maxConcurrentOperationCount = 6
		return queue
	}()

	lazy var filtrationsInProgressBW: [IndexPath: Operation] = [:]
	lazy var filtrationQueueBW: OperationQueue = {
		var queue = OperationQueue()
		queue.name = "Image BW queue"
		queue.maxConcurrentOperationCount = 6
		return queue
	}()


	func suspendAllOperations() {
		downloadQueue.isSuspended = true
		filtrationQueueSepia.isSuspended = true
	}

	func resumeAllOperations() {
		downloadQueue.isSuspended = false
		filtrationQueueSepia.isSuspended = false
	}
	
}
