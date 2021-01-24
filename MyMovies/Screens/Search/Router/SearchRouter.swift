//
//  SearchRouter.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import UIKit

class SearchRouter: SearchRouterInput {

	let routers: RouterImp
	weak var presenter: SearchPresenter?
	
	init(router: RouterImp) {
		self.routers = router
	}

	func openMovieDetail(id:Int, animated:Bool) {
		
		let rootViewController = UINavigationController()

		let childRouter = RouterImp(rootController: rootViewController)
		let projectDetails = MovieDetailBuilder.make(router: childRouter, idMovie: id)
		print("push")
		let vc = MainViewController(0)
		routers.push(projectDetails, animated: true)
//		(presenter?.view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
	}
	
}
