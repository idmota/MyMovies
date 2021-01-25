//
//  SearchRouter.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import UIKit

final class SearchRouter: NSObject {
	
	let routers: RouterImp
	weak var presenter: SearchPresenter?
	
	init(router: RouterImp) {
		self.routers = router
	}
}
extension SearchRouter: SearchRouterInput{
	func openMovieDetail(model:MovieModel, animated:Bool) {
		let projectDetails = MovieDetailBuilder.make(router: routers, model: model)
		routers.push(projectDetails, animated: true)
	}
}
