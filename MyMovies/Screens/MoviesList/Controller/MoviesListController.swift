//
//  MoviesListController.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit
final class MoviesListController: UIViewController {
	
	var presenter: MoviesListPresenter?
	var oneColumn = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ColorMode.background
		navigationItem.title = presenter?.urlModel.name
		navigationController?.isNavigationBarHidden = false
		setupView()
		presenter?.didLoadView()
	}
	
	private func setupView() {
		let bBis = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(openMenu))
		navigationItem.leftBarButtonItems = [bBis]
		
		let rSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
		rSearch.tintColor = ColorMode.colorButton

		
		navigationItem.rightBarButtonItems = [rSearch, gridButton]
		[
			collectionView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		setupLayout()
	}
	
	@objc private func showSearchBar() {
		presenter?.didOpenSearchController()
		
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	private lazy var gridButton:UIBarButtonItem = {
		let changePreview = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(changeButton))
		return changePreview
	}()
	
	private func changeGrid() {
		if !oneColumn {
			gridButton.image = UIImage(systemName: "square.grid.2x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal)
			
			oneColumn = true
		} else {
			gridButton.image = UIImage(systemName: "rectangle.grid.1x2")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal)
			oneColumn = false
		}
		
		UIView.animate(withDuration: 0.2) {
			self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
			self.collectionView.collectionViewLayout = self.createCompositionalLayout()
		}
		
	}
	
	@objc private func changeButton() {
		changeGrid()
	}
	private func setupLayout() {
		let constraints = [
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}
	
	private lazy var collectionView:UICollectionView = {
		let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: createCompositionalLayout())
		cv.register(MoviesListCollectionViewOneCell.self)
		cv.register(MoviesListCollectionViewTwoCell.self)
		
		
		cv.delegate = self
		cv.dataSource = self
		cv.prefetchDataSource = self
		
		cv.backgroundColor = ColorMode.background
		cv.contentInsetAdjustmentBehavior = .never
		cv.showsHorizontalScrollIndicator = false
		
		return cv
	}()
	private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
		var countColumn = 1
		if !oneColumn {
			countColumn = 2
		}
		let groupHeight:NSCollectionLayoutDimension = oneColumn ? .absolute(204) :.absolute(231)
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: groupHeight)
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: countColumn)
		let section = NSCollectionLayoutSection(group: group)
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		
		return layout
	}
	
	@objc private func openMenu() {
		presenter?.didOpenCommonMenu()
	}
	
	@objc private func clearCashe() {
		MyCache.sharedInstance.removeAllObjects()
	}
	@objc private func actionReflesh() {
		collectionView.refreshControl?.endRefreshing()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		presenter?.didPressOpenDetail(at: indexPath.row)
	}
	
}
// MARK: - MoviesListProtocol
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
		showFailView(error.localizedDescription)
//		Logger.handleError(error)
	}
}
// MARK: - MoviesListCollectionViewInput
extension MoviesListController: MoviesListCollectionViewInput {
	
	func downloadItemImageForSearchResult(imageURL: URL,
										  completion: @escaping (_ result:Result<UIImage, Error>) -> Void) {
		presenter?.downloadItemImageForSearchResult(imageURL: imageURL, completion: completion)
	}	
}
// MARK: - UICollectionViewDataSourcePrefetching
extension MoviesListController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let lPresenter = presenter else {return 0}
		return lPresenter.currentCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let movie = presenter?.movie(at: indexPath.row)
		if oneColumn {
			let cell:MoviesListCollectionViewOneCell = collectionView.dequeueReusableCell(for: indexPath)
			guard let movie = movie else {return cell}
			cell.delegate = self
			cell.fill(model:movie)
			cell.layoutSubviews()
			return cell
		} else {
			let cell:MoviesListCollectionViewTwoCell = collectionView.dequeueReusableCell(for: indexPath)
			guard let movie = movie else {return cell}
			cell.delegate = self
			cell.fill(model:movie)
			cell.layoutSubviews()
			return cell
			
		}
	}
}
// MARK: - UICollectionViewDataSourcePrefetching
extension MoviesListController: UICollectionViewDataSourcePrefetching {
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		if indexPaths.contains(where: isLoadingCell) {
			presenter?.getMoviesList()
		}
	}
	private func isLoadingCell(for indexPath: IndexPath) -> Bool {
		guard let lPresenter = presenter else {return false}
		return indexPath.row >= lPresenter.currentCount-1
	}
}
