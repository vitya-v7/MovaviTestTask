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

	init() {

	}

    func download(imagePath: String, indexPath: IndexPath, filtrationMode:ImageState, successCallback: @escaping (_ image:UIImage?, _ imagePath:String)  ->()) -> () {
        var operation:Operation? = nil
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            operation = pendingOperations.downloadsInProgress[indexPath]
            if !operation!.isCancelled && operation!.isFinished {
                if operation is ImageDownloadOperation {
                    successCallback((operation as! ImageDownloadOperation).image, imagePath)
                    return
                }
            }
        } else {
            operation = ImageDownloadOperation(imagePath)
            pendingOperations.downloadQueue.addOperation(operation!)
            pendingOperations.downloadsInProgress[indexPath] = operation!
        }

        operation!.completionBlock = {
            if operation!.isCancelled {
                return
            }

            if operation is ImageDownloadOperation {
                successCallback((operation as! ImageDownloadOperation).image, imagePath)
                return
            }
        }
    }

	func startDownload(imagePath: String, indexPath: IndexPath, filtrationMode:ImageState, successCallback: @escaping (_ image:UIImage?, _ imagePath:String)  ->()) -> () {

        switch (filtrationMode) {
        case .normal:
            download(imagePath:imagePath, indexPath:indexPath, filtrationMode:filtrationMode, successCallback:successCallback)
        case .sepia:
            download(imagePath:imagePath, indexPath:indexPath, filtrationMode:filtrationMode) { [weak self] image, imagePath  in
                self?.startFiltrationSepia(image:image, indexPath:indexPath) { filteredImage in
                     successCallback(filteredImage, imagePath)
                }}
        default:
            NSLog("do nothing")
        }
	}

    func startFiltrationSepia(image:UIImage?, indexPath: IndexPath, successCallback: @escaping (UIImage?)  ->()) -> () {

		guard let imageIn = image else { return }

        var operation:Operation? = nil
        if pendingOperations.filtrationsInProgress[indexPath] != nil {
            operation = pendingOperations.filtrationsInProgress[indexPath]
            if !operation!.isCancelled && operation!.isFinished {
                if operation is ImageFiltration {
                    successCallback((operation as! ImageFiltration).image)
                    return
                }
            }
        } else {
            operation = ImageFiltration(imageIn)
            pendingOperations.filtrationQueue.addOperation(operation!)
            pendingOperations.filtrationsInProgress[indexPath] = operation!
        }

        operation!.completionBlock = {
            if operation!.isCancelled {
                return
            }

            if operation is ImageFiltration {
                successCallback((operation as! ImageFiltration).image)
                return
            }
        }
	}
}
