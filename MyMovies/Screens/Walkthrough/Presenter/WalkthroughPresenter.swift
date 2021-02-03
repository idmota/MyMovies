//
//  WalkthroughPresenter.swift
//  MyMovies
//
//  Created by link on 12/21/20.
//
import UIKit

protocol WalkthroughPresenterProtocol: class {
	var totalCount:Int { get }
	func walkthrough(at index: Int) -> WalkthroughModel
	func didOpenMainViewController()
	func didLoadView()
}
protocol WalkthroughControllerProtocol: class {
	func succes()
	func failure(error: Error)
}

final class WalkthroughPresenter: NSObject {
	
	let router: WalkthroughRouterInput
	weak var view:WalkthroughControllerProtocol?
	private var cellsModels:[WalkthroughModel] = []
	var networkService:NetworkServiseProtocol
	
	init(view:WalkthroughControllerProtocol, router:WalkthroughRouterInput, networkService:NetworkServiseProtocol) {
		self.view = view
		self.router = router
		self.networkService = networkService
		
		super.init()
	}
	
}
// MARK: - WalkthroughPresenterProtocol
extension WalkthroughPresenter:WalkthroughPresenterProtocol {
	
	var totalCount: Int {
		return self.cellsModels.count
	}
	
	func walkthrough(at index: Int) -> WalkthroughModel {
		return self.cellsModels[index]
	}
	
	func didLoadView() {
		networkService.getWalkthroughModels { (result) in
			DispatchQueue.main.async {
				switch result {
				case .success(let cellsModels):
					self.cellsModels = cellsModels
					self.view?.succes()
				case .failure(let error):
					self.view?.failure(error: error)
				}
			}
		}
	}
	
	
	func didOpenMainViewController() {
		self.router.openMainViewController()
	}
	
	
}
