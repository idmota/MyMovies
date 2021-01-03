//
//  CommonsMenuRouter.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//

import UIKit
import Foundation


class CommonsMenuRouter: CommonsMenuRouterInput {
	
	let router: RouterImp
	
	weak var presenter: MoviesListPresenter?
	
	init(router: RouterImp) {
		self.router = router
	}

	func openScreen(openModel: CommonsMenuModel) {

		let projectDetails = MoviesListModelFactory.make(router: router, model:openModel)
		router.setRoot(projectDetails, animated: true)
	}
}
