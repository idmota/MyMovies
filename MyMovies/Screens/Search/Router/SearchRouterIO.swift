//
//  SearchRouterIO.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import Foundation
protocol SearchRouterInput: class {
	func openMovieDetail(id:Int, animated:Bool)
	func showFilterView(animated:Bool)
//	func pressSearchButton(searchText:String, animated: Bool)
//	func openCommonMenu(animated:Bool)
}
