//
//  WalkthroughModel.swift
//  MyMovies
//
//  Created by link on 1/26/21.
//

import Foundation
import UIKit

// MARK: - WalkthroughModel
struct WalkthroughModel: Decodable {
	let bGColor: Color
	let bgImage, title, subTitle: String
	let gradient: Gradient
	
	// MARK: - Gradient
	struct Gradient: Decodable {
		let startPoint, endPoint: Point
		let location: [Double]
		let colors: [Color]
	}

	// MARK: - Point
	struct Point: Decodable {
		let value: CGPoint
		init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			let structValue = try container.decode(decodPoint.self)
			self.value = CGPoint(x: structValue.x, y: structValue.y)
		}
	}
	// MARK: - Color
	struct Color: Decodable {
		let value:UIColor
		
		init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			let structColor = try container.decode(decodColor.self)
			self.value = UIColor(displayP3Red: structColor.red/255, green: structColor.green/255, blue: structColor.blue/255, alpha: CGFloat(structColor.alpha))
		}
	}
	
	struct decodColor: Decodable {
		let red, green, blue: CGFloat
		let alpha: Double
	}
	struct decodPoint: Decodable {
		let x, y: Double
	}
}
