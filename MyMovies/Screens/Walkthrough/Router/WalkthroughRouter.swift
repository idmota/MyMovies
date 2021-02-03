//
//  WalkthroughRouter.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//

import UIKit

final class WalkthroughRouter: NSObject {
	
	let router: RouterImp
	
	internal init(router: RouterImp) {
		self.router = router
	}
}

// MARK: - WalkthroughRouterInput
extension WalkthroughRouter: WalkthroughRouterInput {
	func openMainViewController() {
		
		let projectDetails = MoviesListModelFactory.make(router: router, model: .now_playing)
		router.setRoot(projectDetails, animated: true)
		
	}
}

