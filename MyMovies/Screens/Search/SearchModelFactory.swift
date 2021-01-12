//
//  SearchModelFactory.swift
//  MyMovies
//
//  Created by link on 1/6/21.
//

import UIKit

enum SearchModelFactory {
	static func make (router:RouterImp) -> UITableViewController {
		let view = SearchTableViewController()
		let networkService = NetworkService()
		let searchRouter = SearchRouter(router: router)
		let presenter = SearchPresenter(view: view, networkService: networkService,
											router: searchRouter)

		searchRouter.presenter = presenter
		view.presenter = presenter
		return view
	}
}

