//
//  SearchTableViewController.swift
//  MyMovies
//
//  Created by link on 1/10/21.
//

import UIKit

final class SearchTableViewController: UIViewController {
	
	var presenter: SearchPresenterInput!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Search movie"
		view.backgroundColor = ColorMode.background
		setupView()
	}
	
	private func setupView() {
		[
			collectionView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		
		navigationItem.titleView = searchTitleView
		setupLayout()
		
	}
	
	private lazy var searchTitleView:UIView = {
		let v = UIView()
		[
			searchView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			v.addSubview($0)
		}
		return v
	}()
	
	private lazy var searchView:UITextField = {
		
		let searchView = SearchView()
		searchView.delegate = self
		searchView.autocorrectionType = .no
		searchView.becomeFirstResponder()
		return searchView
	}()
	
	private func setupLayout() {
		let array = [
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			searchView.topAnchor.constraint(equalTo: searchTitleView.topAnchor, constant: Space.half),
			searchView.leadingAnchor.constraint(equalTo: searchTitleView.leadingAnchor, constant: Space.single),
			searchView.trailingAnchor.constraint(equalTo: searchTitleView.trailingAnchor, constant: -Space.half),
			searchView.bottomAnchor.constraint(equalTo: searchTitleView.bottomAnchor, constant: -Space.single),
			
			
		]
		NSLayoutConstraint.activate(array)
	}
	
	func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(204))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
		let section = NSCollectionLayoutSection(group: group)
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		
		return layout
	}
	private lazy var collectionView:UICollectionView = {
		let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: createCompositionalLayout())
		cv.register(MoviesListCollectionViewOneCell.self)
		
		cv.delegate = self
		cv.dataSource = self
		cv.prefetchDataSource = self
		
		cv.backgroundColor = ColorMode.background
		cv.contentInsetAdjustmentBehavior = .never
		cv.showsHorizontalScrollIndicator = false
		cv.backgroundView = placeholder
		
		return cv
	}()
	private lazy var placeholder: PlaceholderView = {
		let view = PlaceholderView()
		view.title = "placeholder.title".localized
		return view
	}()
}

extension SearchTableViewController: UICollectionViewDataSourcePrefetching, UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		if indexPaths.contains(where: isLoadingCell) {
			presenter.getNextPage()
		}
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		presenter.didPressOpenDetail(at: indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		placeholder.isHidden = presenter.currentCount != 0
		
		return presenter.currentCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let movie = presenter!.movie(at: indexPath.row)
		let cell:MoviesListCollectionViewOneCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.fill(model:movie)
		return cell
	}
	
	func isLoadingCell(for indexPath: IndexPath) -> Bool {
		return indexPath.row >= presenter!.currentCount-1
	}
	
}

extension SearchTableViewController: SearchProtocol {
	func succes() {
		collectionView.reloadData()
	}
	
	func failure(error: Error) {
		Logger.handleError(error)
	}
	
	
	
	
}
extension SearchTableViewController: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		if let searchText = textField.text {
			presenter.didPressSearchButton(searchText: searchText)
			placeholder.title = "placeholder.searchtitle".localized + " " + searchText
		}
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}
