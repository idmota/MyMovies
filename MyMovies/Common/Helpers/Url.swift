//
//  URL.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import Foundation

enum Url {
//	static var url: String {
//		get {
//			return "https://api.themoviedb.org/3/movie/popular?api_key=\(token)"
//		}
//	}
	static let token: String = "cb606896c629b59ff2130946a21edeeb"
	
	static let urlDetail: String = "https://api.themoviedb.org/3/movie/"
	static let urlYoutube: String = "https://www.youtube.com/watch?v="
	static let urlPoster: String = "https://image.tmdb.org/t/p/"
	
//	static let top_rated: String = "\(urlDetail)top_rated?api_key=\(token)&language=\(Locale.preferredLanguages.first!)&page=1"//&region=\(Locale.current.regionCode!)"
	
	
	//https://api.themoviedb.org/3/movie/550?api_key=cb606896c629b59ff2130946a21edeeb
	
	static let urlList:String = "https://api.themoviedb.org/3/genre/tv/list?api_key=\(token)&language=ru-RU"
	
	//https://api.themoviedb.org/3/genre/tv/list?api_key=cb606896c629b59ff2130946a21edeeb&language=ru-RU
	
	static func getPosterURL(model:MovieModel)->URL? {
		let stringUrl = "\(urlPoster)\(apiImg.logo_sizes.w92)\(model.posterPath)"
		return URL(string: stringUrl)
	}
	static func getBackPosterURL(posterPath:String)->URL? {
		let stringUrl = "\(urlPoster)\(apiImg.backdrop_sizes.w300)\(posterPath)"
		return URL(string: stringUrl)
	}
	
	static func getTopMoviesFromPage(page:Int)->String {
			return "\(urlDetail)top_rated?api_key=\(token)&language=\(Locale.preferredLanguages.first!)&page=\(page)"
	}
	static func getMovieFromId(_ idMovie:Int)->String {
			return "\(urlDetail)\(idMovie)?api_key=\(token)&language=\(Locale.preferredLanguages.first!)"
	}
	static func getUrlFromCategory(_ category:Category,page:Int)->String {
		return "\(urlDetail)\(category.rawValue)?api_key=\(token)&language=\(Locale.preferredLanguages.first!)&page=\(page)"
	}
	static func getTrailerFromId(_ idMovie:Int)->String {
		return "\(urlDetail)\(idMovie)/videos?api_key=\(token)"
	}
	
}
enum Category:String {
	case latest
	case now_playing
	case popular
	case top_rated
	case upcoming
}

enum apiImg {
	enum backdrop_sizes {
		case w300
		case w780
		case w1280
		case original
	}
	enum logo_sizes {
		case w45
		case w92
		case w154
		case w185
		case w300
		case w500
		case original
	}
	enum poster_sizes {
		case w92
		case w154
		case w185
		case w342
		case w500
		case w780
		case original
	}
	enum profile_sizes {
		case w45
		case w185
		case h632
		case original
	}
	enum still_sizes {
		case w92
		case w185
		case w300
		case original
	}
}

