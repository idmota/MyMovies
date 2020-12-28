//
//  CommonsMenuFactory.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import UIKit

struct CommonsMenuBuilder {
	static func make (router:RouterImp) -> CommonsMenuController {
		let view = CommonsMenuController()
////		let networkService = NetworkService()
		let commonsMenuRouter = CommonsMenuRouter(router: router)
		let presenter = CommonsMenuPresenter(view: view, router: commonsMenuRouter)

		view.presenter = presenter
		
		return view
	}
}
