//
//  Logger.swift
//  MyMovies
//
//  Created by link on 11/30/20.
//

import Foundation

enum Logger {
	static func handleError(_ error: Error) {
		if let decodingError = error as? DecodingError {
			switch decodingError {
			case .dataCorrupted(let context):
				print("""
					Decode error: \(context.debugDescription)
					Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))
					""")
			case .keyNotFound(let codingkey, let context):
				print("""
					Decode error: \(context.debugDescription)
					Coding key: \(codingkey.stringValue)
					Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))
					""")
			case .typeMismatch(let type, let context):
				print("""
					Decode error: \(context.debugDescription)
					Type: \(type) Extra: \(context.codingPath.debugDescription) Extra2: \(context.underlyingError.debugDescription)
					Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))
					""")
			case .valueNotFound(let type, let context):
				print("""
					Decode error: \(context.debugDescription)
					Type: \(type) Extra: \(context.codingPath.debugDescription) Extra2: \(context.underlyingError.debugDescription)
					Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))
					""")
			@unknown default:
				print(decodingError.localizedDescription)
			}
		} else {
			print(error.localizedDescription)
		}
	}
}
