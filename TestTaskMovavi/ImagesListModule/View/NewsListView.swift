//
//  NewsListView.swift
//  TestTaskMovavi
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

protocol NewsListViewInput : UIViewController {
	func setInitialState()
	func setViewModel(viewModels: [ViewModelInterface])
	func appendViewModel(viewModel: ViewModelInterface)
}

protocol NewsListViewOutput {
	func viewDidLoadDone()
	func loadNews()
	func nextPageIndicatorShowed()
	func changeModeOfAllViewModels(mode: NewsElementViewModel.ImageState)
}

class NewsListView: UIViewController, NewsListViewInput, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate{

	@IBOutlet var activityIndicator: UIActivityIndicatorView?
	@IBOutlet var tableView: UITableView?


	@IBAction func originalModeButton(_ sender: UIBarButtonItem) {
		output?.changeModeOfAllViewModels(mode: .normal)
	}


	@IBAction func sepiaModeButton(_ sender: UIBarButtonItem) {
		output?.changeModeOfAllViewModels(mode: .sepia)
	}

	@IBAction func blackWhiteModeButton(_ sender: Any) {
		output?.changeModeOfAllViewModels(mode: .blackAndWhite)
	}

	var operationAPIService: OperationImageAPIService?
	
	var output: NewsListViewOutput?
	var newsViewModels = [ViewModelInterface]()
	var indicatorCellVisibleForTheFirstTime = true
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		output?.viewDidLoadDone()
		
	}

	func reloadData() {
		self.tableView?.reloadData()
	}

	func setViewModel(viewModels:[ViewModelInterface]) {
		self.indicatorCellVisibleForTheFirstTime = true
		self.newsViewModels = viewModels
		self.tableView?.reloadData()
	}

	func appendViewModel(viewModel: ViewModelInterface) {
		self.newsViewModels.append(viewModel)
		self.tableView?.reloadData()
	}

	func setInitialState() {
		//	self.searchBar?.returnKeyType = .done
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		/*if tableView?.cellForRow(at: indexPath)?.reuseIdentifier == ImagesElementCell.reuseIdentifier {
		return Constants.heightForNewsCell
		}
		if tableView?.cellForRow(at: indexPath)?.reuseIdentifier == IndicatorViewCell.reuseIdentifier {
		return Constants.heightForActivityIndicatorCell
		}*/
		return 100
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let viewModel = newsViewModels[indexPath.row]
		let viewModelCellIdentifier = viewModel.cellIdentifier()

		if viewModelCellIdentifier == NewsElementCellConstant {
			let cell = tableView.dequeueReusableCell(withIdentifier: viewModelCellIdentifier) as! NewsElementCell
			cell.configureCell(withObject: viewModel as! NewsElementViewModel, indexPath: indexPath, service: operationAPIService!)
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: viewModelCellIdentifier) as! IndicatorViewCell
			return cell
		}
	}

	func tableView(_ tableView: UITableView,
				   willDisplay cell: UITableViewCell,
				   forRowAt indexPath: IndexPath) {
		if indexPath.row % Constants.newsPerPage == 0 && indexPath.row != 0  {
			if cell is IndicatorViewCell, indicatorCellVisibleForTheFirstTime == true {
				indicatorCellVisibleForTheFirstTime = false
				output?.nextPageIndicatorShowed()
			}
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return newsViewModels.count
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? NewsElementCell {
			cell.smallImage.backgroundColor = cell.backgroundColor
		}
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? NewsElementCell {
			tableView.backgroundColor = .white
			cell.smallImage.backgroundColor = cell.backgroundColor
		}
	}


/*	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		//1
		pendingOperations.suspendAllOperations()
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		// 2
		if !decelerate {
		//	loadImagesForOnscreenCells()
			pendingOperations.resumeAllOperations()
		}
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		// 3
	//	loadImagesForOnscreenCells()
		pendingOperations.resumeAllOperations()
	}

*/




	/*func loadImagesForOnscreenCells() {

		if let pathsArray = tableView?.indexPathsForVisibleRows {

			var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
			allPendingOperations.formUnion(pendingOperations.filtrationsInProgress.keys)

			var toBeCancelled = allPendingOperations
			let visiblePaths = Set(pathsArray)
			toBeCancelled.subtract(visiblePaths)

			var toBeStarted = visiblePaths
			toBeStarted.subtract(allPendingOperations)

			for indexPath in toBeCancelled {
				if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
					pendingDownload.cancel()
				}
				pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
				if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
					pendingFiltration.cancel()
				}
				pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
			}

			for indexPath in toBeStarted {
				let recordForProcess = (newsViewModels as! [NewsElementViewModel])[indexPath.row]
				let imageURLString = recordForProcess.imageURL

				operationAPIService.startOperations(for: recordForProcess, at: indexPath, successCallback: URL.init(string: imageURLString)!)
			}
		}
	}*/
}
