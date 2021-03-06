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
	init(view: MovieDetailProtocol, networkService: NetworkServiseProtocol, idMovie: Int)
	func dowloadPictures(pathURL:URL?, completion: @escaping (_ result:UIImage?) -> Void)
	func didLoadView()
}
class MovieDetailPresenter:MovieDetailPresenterProtocol {
	
	var movie: MovieDetailModel?
	private var idMovie: Int
	var networkService:NetworkServiseProtocol?
	unowned var view: MovieDetailProtocol
	var model:MovieModel?
	
	required init(view: MovieDetailProtocol, networkService: NetworkServiseProtocol, idMovie: Int) {
		
		self.idMovie = idMovie
		self.view = view
		self.networkService = networkService
	}
	required init(view: MovieDetailProtocol, networkService: NetworkServiseProtocol, model: MovieModel) {
		self.idMovie = model.id
		self.model = model
		self.view = view
		self.networkService = networkService
	}
	
	func didLoadView() {
		getInfoMovie()
	}
	
	private func getInfoMovie() {
		networkService?.getResponser(url:Url.getMovieFromId(self.idMovie),
									 model: MovieDetailModel.self) { [weak self] result in
			guard let self = self else {return}
			DispatchQueue.main.async {
				switch result {
				case .success(let resultMovies):
					self.movie = resultMovies
					self.view.succes()
				case .failure(let error):
					self.view.failure(error: error)
				}
			}
		}
	}
	
	func dowloadPictures(pathURL: URL?, completion: @escaping (UIImage?) -> Void) {
		if let pathURL = pathURL {
			networkService?.downloadItemImageForSearchResult(imageURL: pathURL, Repeated: true, completion: completion)
		}
	}
}
