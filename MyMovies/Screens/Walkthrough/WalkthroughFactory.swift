//
//  WalkthroughBuilder.swift
//  MyMovies
//
//  Created by link on 12/16/20.
//

import Foundation
import class UIKit.UIViewController

struct WalkthroughBuilder {
	static func make(router:RouterImp) -> UIViewController {
		let view = WalkthroughController() 
		
		let moviesListRouter = WalkthroughRouter(router: router)
		let presenter = WalkthroughPresenter(view: view, router: moviesListRouter)
		
		view.presenter = presenter
		
		
		return view
	}
}
