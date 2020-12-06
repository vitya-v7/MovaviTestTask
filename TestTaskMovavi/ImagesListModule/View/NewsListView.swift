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
	func setViewModels(viewModels: [ViewModelInterface])
}

protocol NewsListViewOutput {
	func viewDidLoadDone()
    func cellWillShow(index: Int)
}

class NewsListView: UIViewController, NewsListViewInput, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

	@IBOutlet var activityIndicator: UIActivityIndicatorView?
	@IBOutlet var tableView: UITableView?
	var output: NewsListViewOutput?
	var newsViewModels: [ViewModelInterface]?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		output?.viewDidLoadDone()
		
	}

	func reloadData() {
		self.tableView?.reloadData()
	}

	func setViewModels(viewModels:[ViewModelInterface]) {
		self.newsViewModels = viewModels
		self.tableView?.reloadData()
	}

	func setInitialState() {
        // do nothing
	}
	
	/*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}*/
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = newsViewModels![indexPath.row]
        let viewModelCellIdentifier = viewModel.cellIdentifier()

        if viewModelCellIdentifier == NewsElementCellConstant {
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModelCellIdentifier) as! NewsElementCell
            cell.configureCell(withObject: viewModel as! NewsElementViewModel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModelCellIdentifier) as! IndicatorViewCell
            return cell
        }
	}

	func tableView(_ tableView: UITableView,
				   willDisplay cell: UITableViewCell,
				   forRowAt indexPath: IndexPath) {
        output?.cellWillShow(index: indexPath.row)
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
