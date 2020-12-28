//
//  MoviesListRouterIO.swift
//  MyMovies
//
//  Created by link on 12/9/20.
//

import Foundation
protocol MoviesListRouterInput {
	func openMovieDetail(id:Int, animated:Bool)
	func openCommonMenu(animated:Bool)
}
protocol MoviesListRouterOutput {
	func showCommonMenu(animated:Bool)
}
