//
//  RealmManagerInput.swift
//  MyMovies
//
//  Created by Maksyutov Ruslan on 3/6/21.
//

import RealmSwift

protocol RealmManagerInput {
	
	func insertRow<T:Object>(model:T)
	func updateRow<T:Object>(model:T)
	func removeRow<T:Object>(model:T)
	func getFromImageURL<T:Object>(strURL:String) -> T?
	func getRows<T:Object>() -> [T]
	func getNextIncrementID() -> Int
}

