//
//  MoviesListRouter.swift
//  MyMovies
//
//  Created by link on 12/9/20.
//

import UIKit

class MoviesListRouter: MoviesListRouterInput {
	
	let router: RouterImp
	weak var presenter: MoviesListPresenter?
	
	init(router: RouterImp) {
		self.router = router
	}
	
	func openCommonMenu(animated:Bool) {
		presenter?.showCommonMenu(animated: animated)
	}
	
	func openMovieDetail(id:Int, animated:Bool) {
		
		let rootViewController = UINavigationController()

		let childRouter = RouterImp(rootController: rootViewController)
		let projectDetails = MovieDetailBuilder.make(router: childRouter, idMovie: id)
		
		router.push(projectDetails, animated: animated)

	}

	
}
