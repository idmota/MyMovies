//
//  RealmManager.swift
//  MyMovies
//
//  Created by Maksyutov Ruslan on 3/6/21.
//

import RealmSwift

final class RealmManager {
	static let shared:RealmManagerInput = RealmManager()
	fileprivate let database: Realm
	required init() {
		database = try! Realm()
		print(database.configuration.fileURL?.absoluteString)

	}
}
// MARK: - RealmManagerInput
extension RealmManager: RealmManagerInput{
	
	func getFromImageURL<T>(strURL: String) -> T? where T: Object {
		let t = database.objects(T.self).filter("url==%@", strURL).first
		return t
	}
	
	func insertRow<T>(model: T) where T: Object  {
		try! database.write {
			database.add(model, update: .error)
		}
	}
	
	func updateRow<T>(model: T) where T: Object  {
		try! database.write {
			database.add(model, update: .modified)
		}
	}
	
	func removeRow<T>(model: T)  where T: Object{
		try! database.write {
			database.delete(model)
		}
	}
	
	func getRows<T>() -> [T]  where T: Object {
		let resArray:Results<T> = database.objects(T.self).sorted(byKeyPath: "id", ascending: true)
		return resArray.map({$0})
	}
	
	func getNextIncrementID() -> Int {
		return (database.objects(FavoriteMovieModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
	}
}
