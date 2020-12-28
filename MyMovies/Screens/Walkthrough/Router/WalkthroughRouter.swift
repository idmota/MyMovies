//
//  WalkthroughRouter.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//

import Foundation
import UIKit

class WalkthroughRouter: WalkthroughRouterInput {

	let router: Router
	
	weak var presenter: MoviesListPresenter?
	
	init(router: Router) {
		self.router = router
	}
	
	func openMainViewController() {

		let rootViewController = UINavigationController()

		let childRouter = RouterImp(rootController: rootViewController)
		let projectDetails = MoviesListModelFactory.make(router: childRouter)
		router.push(projectDetails, animated: true)
	}
}
