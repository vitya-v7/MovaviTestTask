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
		queue.maxConcurrentOperationCount = 1
		return queue
	}()

	lazy var filtrationsInProgress: [IndexPath: Operation] = [:]
	lazy var filtrationQueue: OperationQueue = {
		var queue = OperationQueue()
		queue.name = "Image Filtration queue"
		queue.maxConcurrentOperationCount = 1
		return queue
	}()
}
