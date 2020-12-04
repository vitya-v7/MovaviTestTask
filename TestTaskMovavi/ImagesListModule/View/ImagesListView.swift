//
//  ImagesListView.swift
//  TestTask
//
//  Created by Viktor D. on 16.08.2020.
//  Copyright © 2020 Viktor D. All rights reserved.
//

import UIKit

protocol ImagesListViewInput : UIViewController {
	func setInitialState()
	func setViewModel(viewModels: [NewsElementViewModel])

}

protocol ImagesListViewOutput {
	func viewDidLoadDone()
	func loadNews()
}

class ImagesListView: UIViewController, ImagesListViewInput, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

	@IBOutlet var activityIndicator: UIActivityIndicatorView?
	@IBOutlet var tableView: UITableView?
	var output: ImagesListViewOutput?
	
	var viewModels: [NewsElementViewModel]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		self.tableView?.estimatedRowHeight = 0
		output?.viewDidLoadDone()
		
	}

	func setViewModel(viewModels:[NewsElementViewModel]) {
		self.viewModels = viewModels
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
		if indexPath.row % Constants.newsPerPage == 0 && indexPath.row != 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: IndicatorViewCell.reuseIdentifier) as! IndicatorViewCell
			return cell
		}
		else {
			let cell = tableView.dequeueReusableCell(withIdentifier: ImagesElementCell.reuseIdentifier) as! ImagesElementCell
			cell.configureCell(withObject: viewModels![indexPath.row])
			return cell
		}

		
	}

	func tableView(_ tableView: UITableView,
				   willDisplay cell: UITableViewCell,
				   forRowAt indexPath: IndexPath) {
		if indexPath.row % Constants.newsPerPage == 0 && indexPath.row != 0 {
			if let cell = cell as? IndicatorViewCell {
				cell.activityIndicator?.startAnimating()
				//tableView.beginUpdates()
				//tableView.deleteRows(at: [indexPath], with: .bottom)
				//tableView.endUpdates()
				output?.loadNews()
			}
		}
	}


	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let viewModels = self.viewModels {
			return viewModels.count + 1
		}
		return 0
	}

	//MARK: UISearchBarDelegate
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if let text = searchBar.text, text != "" {
		}
		searchBar.endEditing(true)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? ImagesElementCell {
			cell.smallImage.backgroundColor = cell.backgroundColor
		}
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? ImagesElementCell {
			tableView.backgroundColor = .white
			cell.smallImage.backgroundColor = cell.backgroundColor
		}
	}

}
