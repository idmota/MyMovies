//
//  SearchPresenter.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import UIKit

protocol SearchPresenterInput: class {
	func didOpenMovieDetail(id:Int, animated:Bool)
	func didShowFilterView(animated:Bool)
}


protocol SearchProtocol: class { // for controller
	
//	var menuView: UIView {get}
	
	func succes()
	func failure(error:Error)
	
	
}

class SearchPresenter:SearchPresenterInput {
	
	weak var view:SearchProtocol!
	let networkService: NetworkService
	let router: SearchRouter
	
	required init(view:SearchProtocol, networkService: NetworkService, router: SearchRouter) {
		self.view = view
		self.networkService = networkService
		self.router = router
	}
//	required init(view: MoviesListProtocol, networkService: NetworkService,
//				  urlModel:CommonsMenuModel, router: MoviesListRouter) {
//		self.view = view

	func didOpenMovieDetail(id: Int, animated: Bool) {
		
	}
	
	func didShowFilterView(animated: Bool) {
		
	}

}
