//
//  MovieDetailViewIO.swift
//  MyMovies
//
//  Created by link on 1/2/21.
//
import UIKit

protocol MovieDetailViewDelegateOutput: class {
	func dowloadPictures(pathURL:URL?, completion: @escaping (_ result:UIImage?) -> Void)
}
protocol MovieDetailViewDelegateInput: class {
	func fillViewFromModel(model:MovieDetailModel)
}
