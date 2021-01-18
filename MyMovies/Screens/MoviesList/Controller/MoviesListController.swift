//
//  MoviesListController.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit
class MoviesListController: UIViewController {
	
	var presenter: MoviesListPresenter?
	var oneColumn = true
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = presenter?.urlModel.name
		navigationController?.isNavigationBarHidden = false
//		navigationController?.navigationBar.prefersLargeTitles = true
//		navigationControll
//		navigationController!.navigationBar.alpha = 0.1
		navigationController?.hidesBarsOnSwipe = true
		setupView()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
//		navigationController?.hidesBarsOnSwipe = true
		navigationController?.isNavigationBarHidden = false
	}
	
//	var isFiltering: Bool {
//		let searchBarScopeIsFiltering = navigationItem.searchController?.searchBar.selectedScopeButtonIndex != 0
//		return navigationItem.searchController!.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
//	}
//	var isSearchBarEmpty: Bool {
//		return navigationItem.searchController?.searchBar.text?.isEmpty ?? true
//	}
	private func setupView() {


		let bBis = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(openMenu))
		navigationItem.leftBarButtonItems = [bBis]
		
		let rSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
		rSearch.tintColor = ColorMode.colorButton
		
		
		navigationItem.rightBarButtonItems = [rSearch, gridButton]
//		view = collectionView

		[
//			leftMenuView,
			collectionView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		setupLayout()
	}
	@objc func showSearchBar() {
		presenter?.didOpenSearchController()

	}
//	override func viewDidLayoutSubviews() {
//		super.viewDidLayoutSubviews()
////		colViewLayout.itemSize = collectionView.frame.size
//	}

	lazy var gridButton:UIBarButtonItem = {
		let changePreview = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(changeButton))
		// rectangle.grid.1x2
		// square.grid.2x2
		return changePreview
	}()
//	var gb2x2: Bool = true
	func changeGrid() {
//		gb2x2 = !gb2x2
		if !oneColumn {
			gridButton.image = UIImage(systemName: "square.grid.2x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal)
			
			oneColumn = true
//			gridButton.image?.size = CGSize(width: 20, height: 20)
		} else {
			gridButton.image = UIImage(systemName: "rectangle.grid.1x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal)
			oneColumn = false
			//			gridButton.image?.size = CGSize(width: 20, height: 20)
		}
		collectionView.reloadData()
		UIView.animate(withDuration: 0.2) {
			self.collectionView.collectionViewLayout = self.createCompositionalLayout()
		}
	}

	@objc func changeButton() {
		changeGrid()
	}
	private func setupLayout() {
		let constraints = [
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}



	lazy var collectionView:UICollectionView = {
		let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: createCompositionalLayout())
		cv.register(MoviesListCollectionViewCell.self)
		cv.register(MoviesListTableViewCell.self)
		
		cv.delegate = self
		cv.dataSource = self
		cv.prefetchDataSource = self
		
		cv.backgroundColor = ColorMode.background
		cv.contentInsetAdjustmentBehavior = .never
		cv.showsHorizontalScrollIndicator = false
//		cv.collectionViewLayout = createCompositionalLayout

		return cv
	}()
	func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
//	  let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
//										   heightDimension: .fractionalHeight(1.0))
//	  let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//	  let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//											 heightDimension: .fractionalWidth(0.5))
//	  let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		let groupHeight:NSCollectionLayoutDimension = oneColumn ? .absolute(204) :.absolute(231)
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: groupHeight)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
//		item.contentInsets = NSDirectionalEdgeInsets(top: Space.half, leading: Space.single, bottom: Space.half, trailing: Space.single)
		var countColumn = 1
		if !oneColumn {
			countColumn = 2
		}

		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))//fractionalHeight(0.4))

		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: countColumn)
		print("set colum")
	  let section = NSCollectionLayoutSection(group: group)
		
//		let section = NSCollectionLayoutSection(group: group)
//		section.orthogonalScrollingBehavior = .paging
//		section.interGroupSpacing = 16
	
	  let layout = UICollectionViewCompositionalLayout(section: section)
//		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

	  return layout
	}
	@objc func openMenu() {
		presenter!.didOpenCommonMenu()
	}

	@objc func clearCashe() {
		MyCache.sharedInstance.removeAllObjects()
	}
	@objc func actionReflesh() {
		collectionView.refreshControl?.endRefreshing()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter!.didPressOpenDetail(at: indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		presenter!.didPressOpenDetail(at: indexPath.row)
		}

}
//extension MoviesListController: UITableViewDelegate, UITableViewDataSource {
//	
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//		let cell:MoviesListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//
//		let movie = presenter!.movie(at: indexPath.row)
//
//		cell.fill(model:movie)
//
//		return cell
//	}
//	
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return presenter?.currentCount ?? 0
//	}
//}
extension MoviesListController: UITableViewDataSourcePrefetching {
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		if indexPaths.contains(where: isLoadingCell) {
			presenter!.getMoviesList()
		}
	}
}
private extension MoviesListController {
	func isLoadingCell(for indexPath: IndexPath) -> Bool {
		return indexPath.row >= presenter!.currentCount-1
	}
}
extension MoviesListController: MoviesListProtocol {
	var menuView: UIView {
		get {
			return self.view
		}
	}
	
	func succes() {
		collectionView.reloadData()
	}
	
	func failure(error: Error) {
		Logger.handleError(error)
	}
	

}
extension MoviesListController: UICollectionViewDelegate, UICollectionViewDataSourcePrefetching, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		if indexPaths.contains(where: isLoadingCell) {
			presenter!.getMoviesList()
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return presenter!.currentCount
	}
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		
		let movie = presenter!.movie(at: indexPath.row)
		if oneColumn {
			let cell:MoviesListTableViewCell = collectionView.dequeueReusableCell(for: indexPath)
			cell.fill(model:movie)
			return cell
		} else {
			let cell:MoviesListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
			cell.fill(model:movie)
			return cell
			
		}
		
		
	}
	
	
}
