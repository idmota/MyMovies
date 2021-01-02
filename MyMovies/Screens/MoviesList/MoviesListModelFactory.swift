//
//  MoviesListFactory.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import Foundation
import class UIKit.UIViewController


enum MoviesListModelFactory {
	static func make (router:RouterImp, model: CommonsMenuModel) -> UIViewController {
		let view = MoviesListController()
		let networkService = NetworkService()
		let moviesListRouter = MoviesListRouter(router: router)
		let presenter = MoviesListPresenter(view: view, networkService: networkService,
											urlModel:model, router: moviesListRouter)
		
		let commonMenu = CommonsMenuBuilder.make(router: router)
		presenter.commonMenu = commonMenu
		
		moviesListRouter.presenter = presenter
		
		router.setRoot(view, animated: false)
		view.presenter = presenter
		return view
	}
}

