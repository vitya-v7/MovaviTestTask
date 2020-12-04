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
	func showLoading(show: Bool)
}

protocol ImagesListViewOutput {
	func viewDidLoadDone()
	func loadNews()
}

class ImagesListView: UIViewController, ImagesListViewInput, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
	@IBOutlet var searchBar: UISearchBar?
	@IBOutlet var activityIndicator: UIActivityIndicatorView?
	@IBOutlet var tableView: UITableView?
	var output: ImagesListViewOutput?
	
	var viewModels: [NewsElementViewModel]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		output?.viewDidLoadDone()
		
	}
	
	func showLoading(show: Bool) {
		if show {
			self.activityIndicator?.startAnimating()
		}
		else {
			self.activityIndicator?.stopAnimating()
		}
	}
	
	func setViewModel(viewModels:[NewsElementViewModel]) {
		self.viewModels = viewModels
		self.tableView?.reloadData()
	}
	
	func setInitialState() {
		self.searchBar?.returnKeyType = .done
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 220
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ImagesElementCell.reuseIdentifier) as! ImagesElementCell
		cell.configureCell(withObject: viewModels![indexPath.row])
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModels?.count ?? 0
	}
	
	//MARK: UISearchBarDelegate
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if let text = searchBar.text, text != "" {
			//output?.loadImages()
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
