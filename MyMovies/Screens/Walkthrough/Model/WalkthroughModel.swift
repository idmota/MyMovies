//
//  WalkthroughModel.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//

import UIKit

struct WalkthroughModel {
	var bGColor:UIColor
	var bgImage:UIImage
	var title:String
	var subTitle: String
	var gradient:gradient
	
	struct gradient {
		var startPoint: CGPoint
		var endPoint: CGPoint
		var location:[NSNumber]?
		var colors:[UIColor]
	}
	
}
