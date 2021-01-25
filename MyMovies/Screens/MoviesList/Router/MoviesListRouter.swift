//
//  MoviesListRouter.swift
//  MyMovies
//
//  Created by link on 12/9/20.
//

import UIKit

final class MoviesListRouter: MoviesListRouterInput {
	
	let router: RouterImp
	weak var presenter: MoviesListPresenter?
	
	init(router: RouterImp) {
		self.router = router
	}
	
	func openCommonMenu(animated:Bool) {
		presenter?.showCommonMenu(animated: animated)
	}
	func openSearchController(animated:Bool) {
		
		let projectDetails = SearchModelFactory.make(router:router)
		router.push(projectDetails, animated: true)
		
	}
	func openMovieDetail(id:Int, animated:Bool) {
		
		let projectDetails = MovieDetailBuilder.make(router: router, idMovie: id)
		router.push(projectDetails, animated: animated)
		
	}
	func openMovieDetail(model: MovieModel, animated: Bool) {
		let projectDetails = MovieDetailBuilder.make(router: router, model: model)
		router.push(projectDetails, animated: animated)
	}
}
