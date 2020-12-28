//
//  MovieGenreListBuilder.swift
//  MyMovies
//
//  Created by link on 11/24/20.
//

import UIKit
struct MovieGenreListBuilder {
	static func make (router:RouterImp) -> UIViewController {
		let view = MovieGenreListController()
		let networkService = NetworkService()
		let presenter = MovieGenrePresenter(view: view, networkService: networkService)
		view.presenter = presenter
		return view
	}
}
