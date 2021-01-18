//
//  SearchView.swift
//  MyMovies
//
//  Created by link on 1/12/21.
//

import UIKit

class SearchView: UITextField {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .systemGray6
		self.placeholder = "Search movie"
		self.attributedPlaceholder =  NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: ColorMode.colorButton])
		self.returnKeyType = .search

		self.layer.cornerRadius = 8.0
		self.layer.masksToBounds = true

		translatesAutoresizingMaskIntoConstraints = false

		let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(ColorMode.colorButton, renderingMode: .alwaysOriginal)
		let imageView = UIImageView(image: searchIcon)
		leftView = imageView
		leftViewMode = .always
		clearButtonMode = .whileEditing

	}

	override var intrinsicContentSize: CGSize {
		return UIView.layoutFittingExpandedSize
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		 let rect = super.leftViewRect(forBounds: bounds)
		return rect.offsetBy(dx: Space.single, dy: 0)
	}
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.textRect(forBounds: bounds)
		return rect.offsetBy(dx: Space.single, dy: 0)
	}
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.editingRect(forBounds: bounds)
		return rect.offsetBy(dx: Space.single, dy: 0)
	}
	
}
