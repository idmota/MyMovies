//
//  SceneDelegate.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
	
		guard let windowScene = (scene as? UIWindowScene) else {
			return
		}
		window = UIWindow(windowScene: windowScene)
		window?.makeKeyAndVisible()
		
		let rootViewController = UINavigationController()
		
		window?.rootViewController = rootViewController
		
		let router = RouterImp(rootController: rootViewController)
		let projectsViewController =  WalkthroughBuilder.make(router: router)
		
		router.setRoot(projectsViewController, animated: true)
	}
	
}

