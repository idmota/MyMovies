//
//  MoviesListRouter.swift
//  MyMovies
//
//  Created by link on 12/9/20.
//

import UIKit

class MoviesListRouter: MoviesListRouterInput {
	
	let router: Router
	weak var presenter: MoviesListPresenter?
	
	init(router: Router) {
		self.router = router
	}
	
	func openCommonMenu(animated:Bool) {
		presenter?.showCommonMenu(animated: animated)
	}
	

	
	func openMovieDetail(id:Int, animated:Bool) {
		let navigationController = UINavigationController()
		let childRouter = RouterImp(rootController: navigationController)
		let projectDetails = MovieDetailBuilder.make(router: childRouter, idMovie:id)
		guard let v = presenter?.view as? UIViewController else {
			return
		}
		router.push(projectDetails, animated: animated)

	}
	
}
