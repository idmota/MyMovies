//
//  Color.swift
//  MyMovies
//
//  Created by link on 12/20/20.
//

import UIKit

extension UIColor {
	convenience init(red:Int, green:Int, blue:Int, alpha:CGFloat) {
		self.init(displayP3Red:CGFloat(red/255), green:CGFloat(green/255), blue:CGFloat(blue/255), alpha:alpha)
	}
	
	public convenience init(hexWithPrefix: String,alpha:CGFloat) {
		let r, g, b: CGFloat
		
		if hexWithPrefix.hasPrefix("#") {
			let start = hexWithPrefix.index(hexWithPrefix.startIndex, offsetBy: 1)
			let hexColor = String(hexWithPrefix[start...])
			
			if hexColor.count == 6 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					
					self.init(displayP3Red: r, green: g, blue: b, alpha: alpha)
					return
				}
			}
		}
		self.init()
		
	}
}
