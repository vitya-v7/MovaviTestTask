//
//  IndicatorViewCell.swift
//  TestTaskMovavi
//
//  Created by Admin. on 04.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class IndicatorViewCell: UITableViewCell {
	
	@IBOutlet var activityIndicator: UIActivityIndicatorView?
	
	var viewModel: IndicatorViewModel?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		activityIndicator?.startAnimating()
	}
	
	func configureCell(withObject object: IndicatorViewModel?) {
		viewModel = object
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
