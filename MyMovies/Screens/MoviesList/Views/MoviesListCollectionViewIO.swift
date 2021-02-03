//
//  MoviesListCollectionViewIO.swift
//  MyMovies
//
//  Created by link on 2/3/21.
//

import Foundation
import class UIKit.UIImage

protocol MoviesListCollectionViewInput:class {
	func downloadItemImageForSearchResult(imageURL: URL,
											completion: @escaping (_ result:Result<UIImage, Error>) -> Void)
}
