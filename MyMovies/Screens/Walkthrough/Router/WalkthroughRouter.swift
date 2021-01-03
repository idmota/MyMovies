//
//  WalkthroughRouter.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//

import Foundation
import UIKit

class WalkthroughRouter: WalkthroughRouterInput {


	let router: RouterImp
	
	internal init(router: RouterImp) {
		self.router = router
	}
	
	func openMainViewController() {

		let projectDetails = MoviesListModelFactory.make(router: router, model: CommonsMenuModel(name: "Top Movies", icon: nil, category: .now_playing))
		router.setRoot(projectDetails, animated: true)

	}
}

