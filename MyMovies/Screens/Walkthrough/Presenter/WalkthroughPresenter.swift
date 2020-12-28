//
//  WalkthroughPresenter.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//
import UIKit
import Foundation

protocol WalkthroughPresenterProtocol: class {
	init(view:WalkthroughController,router:WalkthroughRouterInput)

	var totalCount:Int { get }
	func walkthrough(at index: Int) -> WalkthroughModel
	func didOpenMainViewController()
}

class WalkthroughPresenter: WalkthroughPresenterProtocol {
	
	var totalCount: Int {
		return cellsModels.count
	}
	
	func walkthrough(at index: Int) -> WalkthroughModel {
		return cellsModels[index]
	}
	
	
	let router: WalkthroughRouterInput!
	
	weak var view:WalkthroughController?
	
	var cellsModels:[WalkthroughModel]!

	required init(view:WalkthroughController, router:WalkthroughRouterInput) {
		self.view = view
		self.router = router
		
		fillModel()

	}
	
	func didOpenMainViewController() {
		router.openMainViewController()
	}
	
	
	private func fillModel() {
		self.cellsModels = [
			WalkthroughModel(bGColor: .black, bgImage: UIImage(named: "bg1")!,
							title: "Get the first", subTitle: "Movie &TV information",
							gradient: .init(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1),location: [0.1,0.5],
							colors: [
								UIColor(displayP3Red: 245/255, green: 144/255, blue: 14/255, alpha: 0.17),
								UIColor(displayP3Red: 219/255, green: 49/255, blue: 103/255, alpha: 1)])),
			
			WalkthroughModel(bGColor: .black, bgImage: UIImage(named: "bg2")!,
							 title: "Know the movie", subTitle: "is not worth Watching",
							 gradient: .init(startPoint: CGPoint(x: 0.4, y: 0.3), endPoint: CGPoint(x: 0.8, y: 0.9),location: [0,0.8],
							colors: [
									UIColor(displayP3Red: 245/255, green: 213/255, blue: 71/255, alpha: 0),
									UIColor(displayP3Red: 245/255, green: 213/255, blue: 71/255, alpha: 0.4)
									])),
			WalkthroughModel(bGColor: .black, bgImage: UIImage(named: "bg3")!,
							title: "Real-time", subTitle: "updates movie Trailer",
							gradient: .init(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1),location: [0,0.7],
							colors: [
									UIColor(displayP3Red: 52/255, green: 92/255, blue: 197/255, alpha: 0),
									UIColor(displayP3Red: 20/255, green: 34/255, blue: 70/255, alpha: 1)
									]))

		]
	}
}
