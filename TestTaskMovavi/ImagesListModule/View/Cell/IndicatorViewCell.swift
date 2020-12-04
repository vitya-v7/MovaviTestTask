//
//  IndicatorViewCell.swift
//  TestTaskMovavi
//
//  Created by Admin on 04.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class IndicatorViewCell: UITableViewCell {

	@IBOutlet var activityIndicator: UIActivityIndicatorView?
    override func awakeFromNib() {
        super.awakeFromNib()
		activityIndicator?.startAnimating()
        // Initialization code
    }
	static let reuseIdentifier = "ActivityCellIdentifier"
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
