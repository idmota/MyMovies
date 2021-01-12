//
//  SearchRouter.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import Foundation
class SearchRouter: SearchRouterInput {

	let router: RouterImp
	weak var presenter: SearchPresenter?
	
	init(router: RouterImp) {
		self.router = router
	}

	func openMovieDetail(id: Int, animated: Bool) {
		print("openMovieDetail")
	}
	
	func showFilterView(animated: Bool) {
		print("showFilterView")
	}
}
