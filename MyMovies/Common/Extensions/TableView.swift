//
//  TableView.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit
extension UITableView {
	func register<T>(_ type: T.Type) where T: UITableViewCell {
		let identifier = String(describing: T.self)
		self.register(T.self, forCellReuseIdentifier: identifier)
	}

	func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
		let identifier = String(describing: T.self)
		let defaultCell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		guard let cell = defaultCell as? T else {
			fatalError()
		}
		return cell
	}
}

extension UICollectionView {
	func register<T>(_ type: T.Type) where T: UICollectionViewCell {
		let identifier = String(describing: T.self)
		self.register(T.self, forCellWithReuseIdentifier: identifier)
	}

	func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell {
		let identifier = String(describing: T.self)
		let defaultCell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
		guard let cell = defaultCell as? T else {
			fatalError()
		}
		return cell
	}
}
