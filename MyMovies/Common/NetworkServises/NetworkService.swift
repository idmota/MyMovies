//
//  ApiProvider.swift
//  MyMovies
//
//  Created by link on 11/20/20.
//

import Foundation

protocol NetworkServiseProtocol {
	func getResponser<T:Codable>(url:String, model:T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService:NetworkServiseProtocol {
	func getResponser<T>(url:String, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
		guard let requestUrl = URL(string: url) else {
			completion(.failure(NSError(domain: "error.URLIsNotCorrect", code: 0, userInfo: nil)))
			return
		}
		
		URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
			}
			
			do {
				let retData:T =  try JSONDecoder().decode(T.self,
														  from: data!)
				completion(.success(retData))
			} catch {
				completion(.failure(error))
				
			}
		}.resume()
		
	}
}

