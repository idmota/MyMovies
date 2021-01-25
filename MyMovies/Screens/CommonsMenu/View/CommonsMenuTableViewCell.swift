//
//  CommonsMenuTableViewCell.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//

import UIKit

final class CommonsMenuTableViewCell: UITableViewCell {
	func make(menuModel:CommonsMenuModel) {
		bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
		textLabel?.text = menuModel.name
	}
}

