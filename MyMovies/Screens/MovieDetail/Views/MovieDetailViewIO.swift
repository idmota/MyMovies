//
//  MovieDetailViewIO.swift
//  MyMovies
//
//  Created by link on 1/2/21.
//

import Foundation

protocol MovieDetailViewDelegateOutput: class {
	func openLink()
	func shareMovie() // mb link? or id?
	func PlayTrailer()
}
protocol MovieDetailViewDelegateInput: class {
	func fillViewFromModel(model:MovieDetailModel)
}
