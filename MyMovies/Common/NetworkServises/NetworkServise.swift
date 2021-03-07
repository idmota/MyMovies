//
//  NetworkService.swift
//  MyMovies
//
//  Created by link on 11/20/20.
//
import UIKit
import Foundation

protocol NetworkServiseProtocol {
	func getResponser<T:Codable>(url:String, model:T.Type, completion: @escaping (Result<T, Error>) -> Void)
	func getWalkthroughModels(completion: @escaping (Result<[WalkthroughModel], Error>) -> Void)
	func downloadItemImageForSearchResult(imageURL: URL?, Repeated: Bool,
										  completion: @escaping (_ result:UIImage?) -> Void)
	func downloadItemImageForSearchResult(imageURL: URL,
										  completion: @escaping (_ result:Result<UIImage, Error>) -> Void)
}

class NetworkService:NetworkServiseProtocol {
	func getResponser<T>(url:String, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
		guard let requestUrl = URL(string: url) else {
			completion(.failure(NSError(domain: "error.URLIsNotCorrect", code: 0, userInfo: nil)))
			return
		}
		let sessionConfig = URLSessionConfiguration.default
		sessionConfig.timeoutIntervalForRequest = 5
		sessionConfig.timeoutIntervalForResource = 5
		URLSession(configuration: sessionConfig).dataTask(with: requestUrl) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
				return
			}
			//guard let data = data else { completion(.failure(error!)); return}
			do {
				let retData:T =  try JSONDecoder().decode(T.self,
														  from: data!)
				completion(.success(retData))
			} catch {
				completion(.failure(error))
				
			}
		}.resume()
		
	}
//	func getResponser<T>(requestUrl:URL, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
//		let sessionConfig = URLSessionConfiguration.default
//		sessionConfig.timeoutIntervalForRequest = 5
//		sessionConfig.timeoutIntervalForResource = 10
//
//		URLSession(configuration: sessionConfig).dataTask(with: requestUrl) { (data, response, error) in
//			if let error = error {
//				completion(.failure(error))
//			}
//			do {
//				let retData:T =  try JSONDecoder().decode(T.self,
//														  from: data!)
//				completion(.success(retData))
//			} catch {
//				completion(.failure(error))
//
//			}
//		}.resume()
//
//	}
	
	func downloadItemImageForSearchResult(imageURL: URL?, Repeated: Bool,
										  completion: @escaping (_ result:UIImage?) -> Void) {
		
		if let urlOfImage = imageURL {
			
			URLSession.shared.downloadTask(
				with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
					DispatchQueue.main.async() {
						if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
							completion(image)
							
						} else {
							
							if Repeated, let self = self {
								DispatchQueue.main.asyncAfter(deadline: .now()+1) {
									self.downloadItemImageForSearchResult(imageURL: imageURL, Repeated: false, completion: completion)
								}
							} else {
								completion(nil)
							}
							
						}
					}
					
				}).resume()
			
		}
	}
	func downloadItemImageForSearchResult(imageURL: URL,
										  completion: @escaping (_ result:Result<UIImage, Error>) -> Void) {
		URLSession.shared.downloadTask(
			with: imageURL as URL, completionHandler: { url, response, error in
				if let error = error {
					completion(.failure(error))
				}
				if let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
					completion(.success(image))
				} else {
					completion(.failure(NSError(domain: "nil data", code: 1, userInfo: nil)))
				}
			}).resume()
		
		
	}
	func getWalkthroughModels(completion: @escaping (Result<[WalkthroughModel], Error>) -> Void) {
		let url = Bundle.main.url(forResource: "Walkthrough", withExtension: "json")!
		getResponser(url: url.absoluteString, model: [WalkthroughModel].self, completion: completion)
	}
}


