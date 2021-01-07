//
//  ApiProvider.swift
//  MyMovies
//
//  Created by link on 11/20/20.
//
import UIKit
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
	func downloadItemImageForSearchResult(imageURL: URL?, Repeated: Bool,
												  completion: @escaping (_ result:UIImage?) -> Void) {
		
		if let urlOfImage = imageURL {
			
			URLSession.shared.downloadTask(
				with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
					DispatchQueue.main.async() {
						if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
							
							//							let imageToCache = image
							completion(image)
							
						} else {
							
							if Repeated, let self = self {
								DispatchQueue.main.asyncAfter(deadline: .now()+1) {
									self.downloadItemImageForSearchResult(imageURL: imageURL, Repeated: false, completion: completion)
								}
							} else {
								print(urlOfImage.description)
								completion(nil)
							}

						}
					}
					
				}).resume()
			
		}
	}
}

