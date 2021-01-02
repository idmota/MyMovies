//
//  MoviesListRouterIO.swift
//  MyMovies
//
//  Created by link on 12/9/20.
//

import Foundation
protocol MoviesListRouterInput: class {
	func openMovieDetail(id:Int, animated:Bool)
	func openCommonMenu(animated:Bool)
}
protocol MoviesListRouterOutput: class {
	func showCommonMenu(animated:Bool)
}
