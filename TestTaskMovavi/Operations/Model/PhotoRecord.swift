//
//  PhotoRecord.swift
//  TestTaskMovavi
//
//  Created by Admin on 06.12.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

//MARK: - PhotoRecord Model

public enum PhotoRecordState {
	case new, downloaded, filtered, failed
}

public class PhotoRecord {
	let name: String
	let url: URL
	var state = PhotoRecordState.new
	var image = UIImage(named: "Placeholder")

	init(name:String, url:URL) {
		self.name = name
		self.url = url
	}
}
