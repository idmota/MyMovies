//
//  MovieDetailPresenter.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import UIKit
protocol MovieDetailProtocol:class {
	func succes()
	func failure(error:Error)

}

protocol MovieDetailPresenterProtocol:class {
	
	var movie: MovieDetailModel? { get }
	init(view: MovieDetailProtocol, networkService: NetworkService, idMovie: Int)
}
class MovieDetailPresenter:MovieDetailPresenterProtocol {
	
	var movie: MovieDetailModel?
	private var idMovie: Int
	weak var networkService:NetworkService?
	weak var view: MovieDetailProtocol?
	
	required init(view: MovieDetailProtocol, networkService: NetworkService, idMovie: Int ) {
		// mb call get network
		self.idMovie = idMovie
		self.view = view
		self.networkService = networkService
		getInfoMovie()
	}
	func getInfoMovie() {
		networkService?.getResponser(url:Url.getMovieFromId(self.idMovie),
									model: MovieDetailModel.self) { [weak self] result in
			guard let self = self else {return}
			DispatchQueue.main.async {
				switch result {
				case .success(let resultMovies):
					self.movie = resultMovies
					self.view?.succes()
				case .failure(let error):
					self.view?.failure(error: error)
				}
			}
			
		}
	}
	
	
}
