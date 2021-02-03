//
//  CommonsMenuPresenter.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import Foundation
import class UIKit.UIImage

protocol CommonsMenuControllerProtocol:class {
	
}

protocol CommonsMenuPresenterProtocol:class {
	var totalCount: Int { get }
	func itemMenu(at index: Int) -> CommonsMenuModel
	func didOpenScreen(at index: Int)
	func didLoadView()
}

final class CommonsMenuPresenter:NSObject  {
	
	var router: CommonsMenuRouterInput
	unowned var view:CommonsMenuControllerProtocol
	private var menuModels:[CommonsMenuModel] = []
	
	init(view: CommonsMenuControllerProtocol, router: CommonsMenuRouterInput) {
		self.view = view
		self.router = router
		super.init()
	}
	
	func itemMenu(at index: Int) -> CommonsMenuModel {
		return menuModels[index]
	}
	
	var totalCount: Int {
		return menuModels.count
	}
	
}
// MARK: - CommonsMenuPresenterProtocol
extension CommonsMenuPresenter: CommonsMenuPresenterProtocol {
	func didLoadView() {
		menuModels = [
			.now_playing,
			.popular,
			.top_rated,
			.upcoming
		]
	}
	
	func didOpenScreen(at index: Int) {
		router.openScreen(openModel: itemMenu(at: index))
	}
}

