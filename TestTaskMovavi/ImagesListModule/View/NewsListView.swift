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
	func setViewModel(viewModels: [AnyObject])
	func appendViewModel(viewModel: AnyObject)
	func removeLastViewModel()
}

protocol NewsListViewOutput {
	func viewDidLoadDone()
	func loadNews()
	func nextPageIndicatorShowed()
}

class NewsListView: UIViewController, NewsListViewInput, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

	@IBOutlet var activityIndicator: UIActivityIndicatorView?
	@IBOutlet var tableView: UITableView?
	var output: NewsListViewOutput?
	var newsViewModels: [AnyObject]?
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
	


	func setViewModel(viewModels:[AnyObject]) {
		self.indicatorCellVisibleForTheFirstTime = true
		self.newsViewModels = viewModels
		self.tableView?.reloadData()
	}

	func appendViewModel(viewModel: AnyObject) {
		print("dasd")
		self.newsViewModels?.append(viewModel)
		self.tableView?.reloadData()
	}

	func removeLastViewModel() {

		//self.tableView?.beginUpdates()
		self.newsViewModels?.removeLast()
		self.tableView?.deleteRows(at: [IndexPath.init(row: self.newsViewModels!.count, section: 0)], with: .fade)
		//self.tableView?.endUpdates()
		self.tableView?.reloadData()
	}

	func setInitialState() {
		//	self.searchBar?.returnKeyType = .done
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		/*if tableView.cellForRow(at: indexPath)?.reuseIdentifier == ImagesElementCell.reuseIdentifier {
			return Constants.heightForNewsCell
		}
		if tableView.cellForRow(at: indexPath)?.reuseIdentifier == IndicatorViewCell.reuseIdentifier {
			return Constants.heightForActivityIndicatorCell
		}*/
		return 100
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if indexPath.row % Constants.newsPerPage == 0 && indexPath.row > 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: IndicatorViewCell.reuseIdentifier) as! IndicatorViewCell
			return cell
		}
		else {
			let cell = tableView.dequeueReusableCell(withIdentifier: NewsElementCell.reuseIdentifier) as! NewsElementCell
			cell.configureCell(withObject: newsViewModels![indexPath.row] as! NewsElementViewModel)
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
		return newsViewModels?.count ?? 0
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

}
