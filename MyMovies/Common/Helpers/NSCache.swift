//
//  NSCache.swift
//  MyMovies
//
//  Created by link on 12/1/20.
//

import Foundation
import UIKit

class MyCache: NSCache <NSString, UIImage> {
	static let sharedInstance:MyCache = {
		let l = MyCache ()
		l.countLimit = 25
		return l
	}()
	
}
