//
//  SearchRouterIO.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import Foundation
protocol SearchRouterInput: class {
	func openMovieDetail(model:MovieModel, animated:Bool)
}
