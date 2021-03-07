//
//  FavoriteMovieModel.swift
//  MyMovies
//
//  Created by Maksyutov Ruslan on 3/6/21.
//

import Foundation
import RealmSwift
 
class FavoriteMovieModel: Object {
	@objc dynamic var id: Int = 0
	@objc dynamic var title: String = ""
	@objc dynamic var image: Data = Data()
	@objc dynamic var url: String = ""
	@objc dynamic var created: NSDate = NSDate()
	
	override static func primaryKey() -> String? {
		return "id"
	  }
//	func convertToModel() -> ListModel {
//		return ListModel(id: id, tags: title, webformatURL: url)
//	}
}

// MARK: - NetworkModelInput
extension FavoriteMovieModel: MovieModelInput {
	
	func nextIncrementID() -> Int {
		return RealmManager.shared.getNextIncrementID()
	}
	
	func setNextIncrementID() {
		self.id = RealmManager.shared.getNextIncrementID()
	}
	
//	func makeFrom(model: ListModel) {
//		self.url = model.webformatURL
//		self.title = model.tags
//		self.created = NSDate()
//		self.setNextIncrementID()
//	}
	
	func nextNumber(currentPage: Int, countNumberInPage: Int) -> Int {
		let maxElement = RealmManager.shared.getNextIncrementID()
		 
		return  (currentPage + countNumberInPage <= maxElement) ? currentPage + countNumberInPage: maxElement
	}
}
