//
//  MovieGenrePresenter.swift
//  MyMovies
//
//  Created by link on 11/24/20.
//

import Foundation
protocol MovieGenreProtocol: class { // input
	func succes()
	func failure(error:Error)
	
	
}

protocol MovieGenrePresenterProtocol: class {
	init(view: MovieGenreProtocol, networkService:NetworkService)
	func getGenreList()
	var genreLists:[MovieGenreModel]? {get set}
}
class MovieGenrePresenter: MovieGenrePresenterProtocol {


	weak var view:MovieGenreProtocol?
	let networkService:NetworkService!
	var genreLists: [MovieGenreModel]?
	
	required init(view: MovieGenreProtocol, networkService: NetworkService) {
		self.view = view
		self.networkService = networkService
//		getGenreList()
	}
	
	func getGenreList() {
		networkService.getResponser(url:Url.urlList,
									model: GenresListModel.self) { [weak self] result in
			guard let self = self else {return}
			DispatchQueue.main.async {
				
				switch result {
				case .success(let genreLists):
					self.genreLists = genreLists.genres
					self.view?.succes()
				case .failure(let error):
					self.view?.failure(error: error)
				}
			}

		}
	}
	
	
	
}
