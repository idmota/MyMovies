//
//  ColorMode.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import Foundation
import UIKit

struct ColorMode {
	static let background: UIColor = {
		return .systemBackground
	}()
	static let titleColor:UIColor = {
		return .label
	}()
	static let colorButton:UIColor = {
		return .systemGray
	}()
	// for gradient orange - red
	static let color1: UIColor = {
		return UIColor(displayP3Red: 249/255, green: 159/255, blue: 0/255, alpha: 1)
	}()
	static let color2: UIColor = {
		return UIColor(displayP3Red: 219/255, green: 48/255, blue: 105/255, alpha: 1)
	}()
}
