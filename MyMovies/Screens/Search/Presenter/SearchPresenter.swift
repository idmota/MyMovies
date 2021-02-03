//
//  SearchPresenter.swift
//  MyMovies
//
//  Created by link on 1/7/21.
//

import UIKit

protocol SearchPresenterInput: class {
	func didPressOpenDetail(at index: Int)
	func didPressSearchButton(searchText:String)
	func getNextPage()
	var currentCount:Int {get}
	var totalCount: Int {get}
	func movie(at index: Int) -> MovieModel
	func downloadItemImageForSearchResult(imageURL: URL,
																				completion: @escaping (_ result:Result<UIImage, Error>) -> Void)
}

protocol SearchProtocol: class {
	
	func succes()
	func failure(error:Error)
}

final class SearchPresenter:NSObject {
	private var moviesList: [MovieModel] = []
	private var currentPage:Int = 1
	private var total:Int = 1
	private var isFetchInProgress = false
	private var searchText:String = ""
	
	unowned var view:SearchProtocol
	let networkService: NetworkServiseProtocol
	let router: SearchRouterInput
	
	
	init(view:SearchProtocol, networkService: NetworkServiseProtocol, router: SearchRouterInput) {
		self.view = view
		self.networkService = networkService
		self.router = router
		super.init()
	}
	
}
// MARK: - SearchPresenterInput
extension SearchPresenter: SearchPresenterInput {
	
	var totalCount: Int {
		return total
	}
	
	var currentCount: Int {
		return moviesList.count
	}
	
	func movie(at index: Int) -> MovieModel {
		return moviesList[index]
	}
	
	func didPressOpenDetail(at index: Int) {
		router.openMovieDetail(model: moviesList[index], animated: true)
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
					if let movies = resultMovies.movies {
						self.currentPage += 1
						self.moviesList.append(contentsOf: movies)
					}
					
					self.view.succes()
				case .failure(let error):
					self.isFetchInProgress = false
					self.view.failure(error: error)
				}
			}
		}
	}
	func downloadItemImageForSearchResult(imageURL: URL,
																				completion: @escaping (_ result:Result<UIImage, Error>) -> Void) {
		networkService.downloadItemImageForSearchResult(imageURL: imageURL, completion: completion)
	}
}

