//
//  MovieModelInput.swift
//  MyMovies
//
//  Created by Maksyutov Ruslan on 3/6/21.
//

protocol MovieModelInput {
	func nextIncrementID() -> Int
	func nextNumber(currentPage: Int, countNumberInPage: Int)  -> Int
}
