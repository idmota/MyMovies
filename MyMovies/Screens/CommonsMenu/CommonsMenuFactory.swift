//
//  CommonsMenuFactory.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import Foundation
import class UIKit.UIViewController

struct CommonsMenuBuilder {
	static func make (router:RouterImp) -> CommonsMenuController {
		let view = CommonsMenuController()
		
		let commonsMenuRouter = CommonsMenuRouter(router: router)
		let presenter = CommonsMenuPresenter(view: view, router: commonsMenuRouter)
		
		view.presenter = presenter
		
		return view
	}
}
