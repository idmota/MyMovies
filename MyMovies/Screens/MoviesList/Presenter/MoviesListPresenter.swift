//
//  MoviesListPresenter.swift
//  MyMovies
//
//  Created by link on 11/27/20.
//
import UIKit
import Foundation

protocol MoviesListInput: class {
	func didPressOpenDetail(at index: Int)
	func didOpenCommonMenu()
}


protocol MoviesListProtocol: class { // input
	var menuView: UIView {get}
	func succes()
	func failure(error:Error)
	
	
}

protocol MoviesListPresenterProtocol: class {
	init(view: MoviesListProtocol, networkService:NetworkService, urlModel:CommonsMenuModel, router: MoviesListRouter)
	func getMoviesList()
//	var genresList: [GenresModel] {get}
	//	var moviesList:MoviesListModel? {get set}
	var totalCount:Int { get }
	var currentCount: Int { get }
	func movie(at index: Int) -> MovieModel
	var urlModel: CommonsMenuModel { get }
}

class MoviesListPresenter: MoviesListPresenterProtocol {
	
//	let urlModel: CommonsMenuModel
	
	var menuIsShow:Bool = false
	weak var view:MoviesListProtocol!
	var networkService:NetworkService
	let router: MoviesListRouterInput
	var commonMenu: CommonsMenuController!

	let urlModel: CommonsMenuModel

	private var moviesList: [MovieModel] = []
	private var genresList: [MovieGenreModel] = []
	private var currentPage:Int = 1
	private var total:Int = 1
	private var isFetchInProgress = false
	
	var totalCount: Int {
		return total
	}
	
	var currentCount: Int {
		return moviesList.count
	}
	
	func movie(at index: Int) -> MovieModel {
		return moviesList[index]
	}
	
	required init(view: MoviesListProtocol, networkService: NetworkService,
				  urlModel:CommonsMenuModel, router: MoviesListRouter) {
		self.view = view
		self.networkService = networkService
		self.urlModel = urlModel
		self.router = router

		getGenresList()
		getMoviesList()
	//		print("init MoviesListPresenter")

	}
	func getGenresList() {
//		let gm:GenresListModel
		let url = Url.getFenresList()
		networkService.getResponser(url:url,
									model: GenresListModel.self) { [weak self] result in
			guard let self = self else {return}
			DispatchQueue.main.async {
				
				switch result {
				case .success(let resultGenres):
	
					self.genresList = resultGenres.genres
					
//					self.view?.succes()
				case .failure(let error):
					print(url)
//					self.isFetchInProgress = false
					self.view?.failure(error: error)
				}
			}
			
		}
	}
	
	func getMoviesList() {
		guard !isFetchInProgress else {
			return
		}
		
		if total < currentPage{
			return
		}
		
		self.isFetchInProgress = true
		let url = Url.getUrlFromCategory(urlModel.category, page: currentPage)
		networkService.getResponser(url:url,
									model: MoviesListModel.self) { [weak self] result in
			guard let self = self else {return}
			DispatchQueue.main.async {
				
				switch result {
				case .success(let resultMovies):
					self.isFetchInProgress = false
					
					self.currentPage += 1
					self.moviesList.append(contentsOf: resultMovies.movies)
					
					self.total = resultMovies.totalPages
					//
					for (index, value) in self.moviesList.enumerated() {
						self.moviesList[index].genre.removeAll()
						let genres = self.genresList.filter { list in
							value.genreIDS.contains(list.id)
						}
						self.moviesList[index].genre.append(contentsOf: genres)
					}
					self.view?.succes()
				case .failure(let error):
					print(url)
					self.isFetchInProgress = false
					self.view?.failure(error: error)
				}
			}
			
		}
	}
	
	
	
}
extension MoviesListPresenter: MoviesListInput {
	func didOpenCommonMenu() {
		router.openCommonMenu(animated: true)
	}
	func didPressOpenDetail(at index: Int) {
		let id = moviesList[index].id
		router.openMovieDetail(id: id, animated: true)
	}
	
	
}
extension MoviesListPresenter: MoviesListRouterOutput {
	func showCommonMenu(animated: Bool) {
		if (menuIsShow)
		{
			menuIsShow = false
			if view.menuView.subviews.count == 1 {
				return
			}
			let viewMenuBack : UIView = view.menuView.subviews.last!
			let color = UIColor.lightGray
			viewMenuBack.backgroundColor = color.withAlphaComponent(0.0)
			UIView.animate(withDuration: 0.3, animations: { () -> Void in
				var frameMenu : CGRect = viewMenuBack.frame
				frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
				viewMenuBack.frame = frameMenu
				viewMenuBack.layoutIfNeeded()
			}, completion: { (finished) -> Void in
				viewMenuBack.removeFromSuperview()
			})
			
			return
		}
		
		menuIsShow = true

		let menuVC : UIViewController = commonMenu

		view!.menuView.addSubview(menuVC.view)

		menuVC.view.translatesAutoresizingMaskIntoConstraints = false
		menuVC.view.topAnchor.constraint(equalTo: view.menuView.safeAreaLayoutGuide.topAnchor).isActive = true
		menuVC.view.leadingAnchor.constraint(equalTo: view.menuView.leadingAnchor).isActive = true
		menuVC.view.trailingAnchor.constraint(equalTo: view.menuView.trailingAnchor).isActive = true
		menuVC.view.bottomAnchor.constraint(equalTo: view.menuView.bottomAnchor).isActive = true
		menuVC.view.frame.origin.x = -UIScreen.main.bounds.size.width
		menuVC.view.layoutIfNeeded()

		let color = UIColor.systemGray
		menuVC.view.backgroundColor = color.withAlphaComponent(0)
		UIView.animate(withDuration: 0.3, animations: { () -> Void in

			menuVC.view.frame.origin.x = 0
			
		},completion: {_ in
			let color = UIColor.systemGray
			menuVC.view.backgroundColor = color.withAlphaComponent(0.6)
		})
		
		let lSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
		lSwipe.direction = .left
		menuVC.view.addGestureRecognizer(lSwipe)
	}
	@objc func leftSwipe() {
		showCommonMenu(animated: true)
	}
	
}
	
	

