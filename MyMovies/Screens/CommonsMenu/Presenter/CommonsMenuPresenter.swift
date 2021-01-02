//
//  CommonsMenuPresenter.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import Foundation

//protocol CommonsMenuPresenterOutput:class {
//
//}
//protocol CommonsMenuPresenterInput:class {
//
//}
protocol CommonsMenuControllerProtocol:class {
	
}

protocol CommonsMenuPresenterProtocol:class {
	init(view: CommonsMenuControllerProtocol, router: CommonsMenuRouterInput)
	var totalCount: Int { get }
	func itemMenu(at index: Int) -> CommonsMenuModel
	func didOpenScreen(at index: Int)
	
	func didHideMenu(animation:Bool)
}

class CommonsMenuPresenter:CommonsMenuPresenterProtocol {
	
	func didOpenScreen(at index: Int) {
		router.openScreen(openModel: itemMenu(at: index))
	}
	
//	var delegate:
	
	var router: CommonsMenuRouterInput!
	weak var view:CommonsMenuControllerProtocol?
	
	var menuModels:[CommonsMenuModel]!
	
	required init(view: CommonsMenuControllerProtocol, router: CommonsMenuRouterInput) {
		self.view = view
		self.router = router
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
			// get new movie
			//https://api.themoviedb.org/3/movie/latest?api_key=<<api_key>>&language=en-US
			//CommonsMenuModel(name: "New movie", icon: nil, category: .latest, urlLink: Url.getUrlFromCategory(.latest, page: 0)),
			//  Today in cinema
			// https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1
			CommonsMenuModel(name: "Today in cinema", icon: nil, category: .now_playing, urlLink: Url.getUrlFromCategory(.now_playing, page: 0)),
			// https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
			CommonsMenuModel(name: "Popular", icon: nil, category: .popular, urlLink: Url.getUrlFromCategory(.popular, page: 0)),
			// https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1
			CommonsMenuModel(name: "Top Rated", icon: nil, category: .top_rated, urlLink: Url.getUrlFromCategory(.top_rated, page: 0)),
			// https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1
			CommonsMenuModel(name: "Upcoming", icon: nil, category: .upcoming, urlLink: Url.getUrlFromCategory(.upcoming, page: 0))
/*
			// https://api.themoviedb.org/3/movie/latest?api_key=<<api_key>>&language=en-US
			// https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1
			// https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
			// https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1
			// https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1

*/
		]
	}
	@objc func didHideMenu(animation: Bool) {
		print("hide")
	}
}
