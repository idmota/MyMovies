//
//  Date.swift
//  MyMovies
//
//  Created by link on 12/8/20.
//

import Foundation
extension Date {
	init(fromString:String) {

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
		dateFormatter.dateFormat = "yyyy-MM-dd"
		if let date = dateFormatter.date(from:fromString) {
			self = date
		} else {
			self.init()
		}
		
	
	}
	var toYearString:String  {
		let formatter1 = DateFormatter()
		formatter1.dateFormat = "yyyy"
		return formatter1.string(from: self)
	}
	
	var toString:String  {
		let formatter1 = DateFormatter()
		formatter1.dateFormat = "dd MMMM yyyy"
		return formatter1.string(from: self)
	}
}
