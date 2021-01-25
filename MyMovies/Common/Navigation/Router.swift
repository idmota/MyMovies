//
//  Router.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit

protocol Router {
	func setRoot(_ controller: UIViewController, animated: Bool)
	func push(_ controller: UIViewController, animated: Bool)
	func present(_ controller: UIViewController, animated: Bool)
	func pop(animated: Bool)
	var rootController: UINavigationController? { get set }
}

final class RouterImp: Router {
	var rootController: UINavigationController?
	
	init(rootController: UINavigationController) {
		self.rootController = rootController
	}
	
	func push(_ controller: UIViewController, animated: Bool) {
		rootController?.pushViewController(controller, animated: animated)
	}
	
	func popToRoot(animated: Bool) {
		_ = rootController?.popToRootViewController(animated: animated)
	}
	func pop(animated: Bool) {
		_ = rootController?.popViewController(animated: animated)
	}
	
	func setRoot(_ controller: UIViewController, animated: Bool) {
		rootController?.setViewControllers([controller], animated: animated)
	}
	
	func present(_ controller: UIViewController, animated: Bool) {
		rootController?.present(controller, animated: animated, completion: nil)
	}
}
