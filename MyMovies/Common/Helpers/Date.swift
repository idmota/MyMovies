//
//  Date.swift
//  MyMovies
//
//  Created by link on 12/8/20.
//

import Foundation
extension Date {
	init(fromString:String) {
//		super.init()
		//let isoDate = "2016-04-14T10:44:00+0000"

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let date = dateFormatter.date(from:fromString)!
		self = date
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
