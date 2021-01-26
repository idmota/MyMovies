//
//  placeholderView.swift
//  MyMovies
//
//  Created by link on 1/21/21.
//

import UIKit

final class PlaceholderView: UIView {
	
	var title: String? {
		set {
			titleLabel.text = newValue
		}
		get {
			return titleLabel.text
		}
	}
	
	var subtitle: String? {
		set {
			subtitleLabel.text = newValue
		}
		get {
			return subtitleLabel.text
		}
	}
	
	// MARK: UI properties
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = UIFont.preferredFont(forTextStyle: .title1)
		label.adjustsFontForContentSizeCategory = true
		return label
	}()
	
	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 5
		label.textAlignment = .center
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		label.adjustsFontForContentSizeCategory = true
		return label
	}()
	
	
	// MARK: Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		[
			titleLabel,
			subtitleLabel
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
		
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: Space.triple),
			titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -Space.triple),
			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
		
			subtitleLabel.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: Space.triple),
			subtitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -Space.triple),
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Space.single)
		])
	}
}
