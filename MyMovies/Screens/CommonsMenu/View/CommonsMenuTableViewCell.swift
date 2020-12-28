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
		textLabel?.text = menuModel.name
		backgroundColor = .green
	}
}
