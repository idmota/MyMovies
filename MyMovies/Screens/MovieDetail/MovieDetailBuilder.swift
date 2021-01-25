//
//  MovieDetailBuilder.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import UIKit
enum MovieDetailBuilder {
	static func make (router:RouterImp,idMovie:Int) -> UIViewController {
		let view = MovieDetailController()
		let networkService = NetworkService()
		let presenter = MovieDetailPresenter(view: view, networkService: networkService, idMovie:idMovie)
		view.presenter = presenter
		return view
	}
	static func make (router:RouterImp,model:MovieModel) -> UIViewController {
		let view = MovieDetailController()
		let networkService = NetworkService()
		let presenter = MovieDetailPresenter(view: view, networkService: networkService, model:model)
		view.presenter = presenter
		return view
	}
}
