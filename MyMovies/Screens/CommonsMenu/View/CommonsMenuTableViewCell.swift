//
//  CommonsMenuTableViewCell.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//

import UIKit

class CommonsMenuTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func make(menuModel:CommonsMenuModel) {
		

		bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
		textLabel?.text = menuModel.name

	}
}

