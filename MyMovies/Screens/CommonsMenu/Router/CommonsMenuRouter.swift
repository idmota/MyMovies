//
//  CommonsMenuRouter.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//

import UIKit

final class CommonsMenuRouter: NSObject {
	
	let router: RouterImp
	
	weak var presenter: MoviesListPresenter?
	
	init(router: RouterImp) {
		self.router = router
	}
}

// MARK: - CommonsMenuRouterInput
extension CommonsMenuRouter: CommonsMenuRouterInput{
	func openScreen(openModel: CommonsMenuModel) {
		let projectDetails = MoviesListModelFactory.make(router: router, model:openModel)
		router.setRoot(projectDetails, animated: true)
		
	}
}
