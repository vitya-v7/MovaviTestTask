//
//  IndicatorViewModel.swift
//  TestTaskMovavi
//
//  Created by Admin on 04.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class IndicatorViewModel: ViewModelInterface {
    func cellIdentifier() -> String {
        return "ActivityCellIdentifier"
    }
	var mode: NewsElementViewModel.ImageState = .none
}
