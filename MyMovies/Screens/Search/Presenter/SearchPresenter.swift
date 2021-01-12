//
//  SearchPresenter.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import UIKit

protocol SearchPresenterInput: class {
	func didOpenMovieDetail(id:Int, animated:Bool)
	func didPressSearchButton(searchText:String)
	func getNextPage()
	var currentCount:Int {get}
	var totalCount: Int {get}
	func movie(at index: Int) -> MovieModel 
}


protocol SearchProtocol: class { // for controller
	
	//	var menuView: UIView {get}
	//	var presenter: SearchPresenterInput {get}
	
	func succes()
	func failure(error:Error)
	
	
}

class SearchPresenter:SearchPresenterInput {

	private var moviesList: [MovieModel] = []
	private var currentPage:Int = 1
	private var total:Int = 1
	private var isFetchInProgress = false
	private var searchText:String!
	
	unowned var view:SearchProtocol
	let networkService: NetworkService
	let router: SearchRouter
	
	var totalCount: Int {
		return total
	}
	
	var currentCount: Int {
		return moviesList.count
	}
	
	func movie(at index: Int) -> MovieModel {
		return moviesList[index]
	}
	required init(view:SearchProtocol, networkService: NetworkService, router: SearchRouter) {
		self.view = view
		self.networkService = networkService
		self.router = router
	}
	//	required init(view: MoviesListProtocol, networkService: NetworkService,
	//				  urlModel:CommonsMenuModel, router: MoviesListRouter) {
	//		self.view = view
	
	func didOpenMovieDetail(id: Int, animated: Bool) {
		router.openMovieDetail(id: id, animated: animated)
	}

	func didPressSearchButton(searchText:String) {
		self.searchText = searchText
		getMovies(newRequest: true)
	}
	func getNextPage() {
		getMovies(newRequest: false)
	}
	
	private func getMovies(newRequest:Bool) {
		
		if newRequest {
			moviesList = []
			currentPage = 1
			total = 1
		}
		
		guard !isFetchInProgress else {
			return
		}
		
		if total < currentPage{
			return
		}
		
		self.isFetchInProgress = true
		let url = Url.getUrlForSearch(searchString: searchText, page: currentPage)
		networkService.getResponser(url: url, model: MoviesListModel.self) { [weak self] result in
			guard let self = self else {return}
			DispatchQueue.main.async {
				
				switch result {
				case .success(let resultMovies):
					self.isFetchInProgress = false
					self.total = resultMovies.totalPages
					self.currentPage += 1
					self.moviesList.append(contentsOf: resultMovies.movies)
					
					self.view.succes()
				case .failure(let error):
					print(url)
					self.isFetchInProgress = false
					self.view.failure(error: error)
				}
			}
		}
	}
}
