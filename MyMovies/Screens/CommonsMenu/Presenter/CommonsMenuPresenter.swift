//
//  CommonsMenuPresenter.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import Foundation

protocol CommonsMenuControllerProtocol:class {
	
}

protocol CommonsMenuPresenterProtocol:class {
	var totalCount: Int { get }
	func itemMenu(at index: Int) -> CommonsMenuModel
	func didOpenScreen(at index: Int)
}

final class CommonsMenuPresenter:NSObject  {
	
	var router: CommonsMenuRouterInput!
	unowned var view:CommonsMenuControllerProtocol
	private var menuModels:[CommonsMenuModel]!
	
	init(view: CommonsMenuControllerProtocol, router: CommonsMenuRouterInput) {
		self.view = view
		self.router = router
		super.init()
		fillModel()
	}
	
	func itemMenu(at index: Int) -> CommonsMenuModel {
		return menuModels[index]
	}
	
	var totalCount: Int {
		return menuModels.count
	}
	
	private func fillModel() {
		self.menuModels = [
			// https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1
			CommonsMenuModel(name: "Menu.TodayInCinema".localized, icon: nil, category: .now_playing, urlLink: Url.getUrlFromCategory(.now_playing, page: 0)),
			// https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
			CommonsMenuModel(name: "Menu.Popular".localized, icon: nil, category: .popular, urlLink: Url.getUrlFromCategory(.popular, page: 0)),
			// https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1
			CommonsMenuModel(name: "Menu.TopRated".localized, icon: nil, category: .top_rated, urlLink: Url.getUrlFromCategory(.top_rated, page: 0)),
			// https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1
			CommonsMenuModel(name: "Menu.Upcoming".localized, icon: nil, category: .upcoming, urlLink: Url.getUrlFromCategory(.upcoming, page: 0))
		]
	}
}

extension CommonsMenuPresenter: CommonsMenuPresenterProtocol {
	func didOpenScreen(at index: Int) {
		router.openScreen(openModel: itemMenu(at: index))
	}
}
