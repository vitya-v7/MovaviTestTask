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
	func setViewModel(viewModels: [NewsElementViewModel])
	func deleteRows(at indexPath: [IndexPath])
	func reloadData()
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
	var newsViewModels: [NewsElementViewModel]?
	var indicatorViewModel: [IndicatorViewModel]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		self.indicatorViewModel = [IndicatorViewModel]()
		self.indicatorViewModel?.append(IndicatorViewModel())
		//self.tableView?.estimatedRowHeight = 0
		output?.viewDidLoadDone()
		
	}

	func reloadData() {
		self.tableView?.reloadData()
	}
	
	/*func deleteRows(at indexPath: [IndexPath]) {
		UIView.setAnimationsEnabled(false)
		self.tableView?.beginUpdates()
		//cell.textView.scrollRangeToVisible(NSMakeRange(cell.textView.text.characters.count-1, 0))		self.tableView?.deleteRows(at: indexPath, with: .left)
		self.tableView?.endUpdates()
		UIView.setAnimationsEnabled(true)
		self.tableView?.scrollToRow(at: indexPath.first!, at: .bottom, animated: false)
		self.tableView?.reloadData()
		//self.tableView?.beginUpdates()
		/*
		self.tableView?.deleteRows(at: indexPath, with: .left)
		//self.tableView?.endUpdates()
		self.tableView?.reloadData()*/
	}*/



	private var frozenContentOffsetForRowAnimation: CGPoint?

	func deleteRows(at indexPath: [IndexPath]) {
		let originalContentOffset = self.tableView?.contentOffset
		self.tableView?.beginUpdates()
		self.indicatorViewModel?.removeLast()
		self.tableView?.deleteRows(at: indexPath, with: .left)
		self.tableView?.reloadData()

		self.tableView?.endUpdates()

		if self.tableView?.contentOffset != originalContentOffset {
		  frozenContentOffsetForRowAnimation = self.tableView?.contentOffset
	  }
	}

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		frozenContentOffsetForRowAnimation = nil
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if let overrideOffset = frozenContentOffsetForRowAnimation, scrollView.contentOffset != overrideOffset {
			scrollView.setContentOffset(overrideOffset, animated: false)
		}
	}

	func setViewModel(viewModels:[NewsElementViewModel]) {
		self.newsViewModels = viewModels
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
			if let indicatorViewModel = indicatorViewModel {
				cell.configureCell(withObject: indicatorViewModel[0])
			}
			return cell
		}
		else {
			let cell = tableView.dequeueReusableCell(withIdentifier: NewsElementCell.reuseIdentifier) as! NewsElementCell
			cell.configureCell(withObject: newsViewModels![indexPath.row])
			return cell
		}
	}

	func tableView(_ tableView: UITableView,
				   willDisplay cell: UITableViewCell,
				   forRowAt indexPath: IndexPath) {
		if indexPath.row % Constants.newsPerPage == 0 && indexPath.row != 0 {
			if cell is IndicatorViewCell {
				output?.nextPageIndicatorShowed()
			}
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var sum = 0
		if let viewModels = self.newsViewModels {
			sum = sum + viewModels.count
		}
		if let indicatorViewModel = self.indicatorViewModel {
			sum = sum + indicatorViewModel.count
		}
		return sum
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
