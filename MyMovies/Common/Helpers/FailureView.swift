//
//  FailureView.swift
//  MyMovies
//
//  Created by Maksyutov Ruslan on 3/6/21.
//

import UIKit

extension UIViewController {
	func showFailView(_ title: String) {
		let tfailView = failView(title)
		tfailView.frame.origin.y = -100
		tfailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideFailView(sender:))))
		tfailView.isUserInteractionEnabled = true
		navigationController?.view.addSubview(tfailView)
		
		UIView.animate(withDuration: 1) {
			tfailView.frame.origin.y = 0
			tfailView.alpha = 1
		}
	}
	@objc func hideFailView(sender: UIGestureRecognizer) {
		UIView.animate(withDuration: 1) {
			sender.view?.frame.origin.y = -100
			sender.view?.alpha = 0
		}
		
	}
	
	private func failView(_ title: String) -> UIView {
		
		let frame = self.view.frame
		let failView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
		failView.backgroundColor = UIColor.red.withAlphaComponent(0.8)
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: failView.frame.width, height: failView.frame.height))
		
		label.center = failView.center
		label.text = title
		label.textAlignment = .center
		
		failView.addSubview(label)
		//		failView.isHidden = true
		return failView
		
	}
}
