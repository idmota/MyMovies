//
//  MoviesListController.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit
class MoviesListController: UIViewController {
	
	var presenter: MoviesListPresenter!

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = false
		navigationItem.title = "movie list"
				

		setupView()
		
	}
	
	
	private func setupView() {

		let refreshc = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
		refreshc.addTarget(self, action: #selector(actionReflesh), for: .valueChanged)
		refreshc.tintColor = .green
		tableView.refreshControl = refreshc
		
		let bBis = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(openMenu))
		navigationItem.leftBarButtonItems = [bBis]
		
		let rSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openMenu))
		rSearch.tintColor = ColorMode.colorButton
		
		
		navigationItem.rightBarButtonItems = [gridButton,rSearch]


		[
//			leftMenuView,
			tableView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(tableView)
		}
		setupLayout()
	}
	lazy var gridButton:UIBarButtonItem = {
		let changePreview = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(changeButton))
		// rectangle.grid.1x2
		// square.grid.2x2
		return changePreview
	}()
	var gb2x2: Bool = true
	func changeGrid() {
		gb2x2 = !gb2x2
		if gb2x2 {
			gridButton.image = UIImage(systemName: "square.grid.2x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal)
//			gridButton.image?.size = CGSize(width: 20, height: 20)
		} else {
			gridButton.image = UIImage(systemName: "rectangle.grid.1x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal)
//			gridButton.image?.size = CGSize(width: 20, height: 20)
		}
		
	}
	@objc func changeButton() {
		changeGrid()
	}
	private func setupLayout() {
		let constraints = [
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}
//
//	lazy var leftMenuView: UIView = {
//		let mv = UIView()
//		return mv
//	}()
	
	lazy var tableView: UITableView = {
		let tv = UITableView()
		tv.register(MoviesListTableViewCell.self)
		
		tv.prefetchDataSource = self // top update indicator
		tv.delegate = self
		tv.dataSource = self
		
		return tv
	}()
	
	@objc func openMenu() {
		presenter.didOpenCommonMenu()
	}

	@objc func clearCashe() {
		MyCache.sharedInstance.removeAllObjects()
	}
	@objc func actionReflesh() {
		tableView.refreshControl?.endRefreshing()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.didPressOpenDetail(at: indexPath.row)
	}
	

}
extension MoviesListController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:MoviesListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		let movie = presenter.movie(at: indexPath.row)
		
		cell.fill(model:movie)

		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.currentCount
	}
}
extension MoviesListController: UITableViewDataSourcePrefetching {
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		if indexPaths.contains(where: isLoadingCell) {
			presenter.getMoviesList()
		}
	}
}
private extension MoviesListController {
	func isLoadingCell(for indexPath: IndexPath) -> Bool {
		return indexPath.row >= presenter.currentCount-1
	}
}
extension MoviesListController: MoviesListProtocol {
	var menuView: UIView {
		get {
			return self.view
		}
	}
	
	func succes() {
		tableView.reloadData()
	}
	
	func failure(error: Error) {
		Logger.handleError(error)
	}
	

}
