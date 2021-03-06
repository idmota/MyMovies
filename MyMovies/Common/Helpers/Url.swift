//
//  URL.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import Foundation

enum Url {

	static let token: String = "cb606896c629b59ff2130946a21edeeb"
	
	static let urlDetail: String = "https://api.tmdb.org/3/"
	
	static let urlYoutube: String = "https://www.youtube.com/watch?v="
	static let urlPoster: String = "https://image.tmdb.org/t/p/"
	static let urlList:String = "https://api.tmdb.org/3/genre/tv/list?api_key=\(token)&language=ru-RU"
	
	static func getPosterURL(path:String)->URL? {
		let stringUrl = "\(urlPoster)\(apiImg.logo_sizes.w154)\(path)"
		return URL(string: stringUrl)
	}
	static func getBackPosterURL(path:String)->URL? {
		let stringUrl = "\(urlPoster)\(apiImg.backdrop_sizes.w500)\(path)"
		return URL(string: stringUrl)
	}
	static func getPosterURLWithSize(path:String, size:apiImg.poster_sizes)->URL? {
		let stringUrl = "\(urlPoster)\(size)\(path)"
		return URL(string: stringUrl)
	}
	static func getTopMoviesFromPage(page:Int)->String {
			return "\(urlDetail)top_rated?api_key=\(token)&language=\(Locale.preferredLanguages.first!)&page=\(page)"
	}
	static func getMovieFromId(_ idMovie:Int)->String {
		return "\(urlDetail)\(typeData.movie)/\(idMovie)?api_key=\(token)&language=\(Locale.preferredLanguages.first!)&append_to_response=videos"
	}

	static func getUrlFromCategory(_ category:CommonsMenuModel,page:Int)->String {
		return "\(urlDetail)\(typeData.movie)/\(category.rawValue)?api_key=\(token)&language=\(Locale.preferredLanguages.first!)&page=\(page)"
		
	}
	static func getUrlForSearch(searchString:String, page:Int)->String {
		let escapedString = searchString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""
		return "\(urlDetail)search/\(typeData.movie)?api_key=\(token)&language=\(Locale.preferredLanguages.first!)&page=\(page)&query=\(escapedString)"

	}
	
	enum typeStatus {
		case Released
	}
	
	static func getTrailerFromId(_ idMovie:Int)->String {
		return "\(urlDetail)\(typeData.movie)/\(idMovie)/videos?api_key=\(token)"
	}
	static func getFenresList()->String {
		return "\(urlDetail)genre/\(typeData.movie)/list?api_key=\(token)&language=\(Locale.preferredLanguages.first!)"
		//https://api.themoviedb.org/3/genre/movie/list?api_key=cb606896c629b59ff2130946a21edeeb&language=ru-RU

	}

}
enum typeData:String {
	case movie
	case tv
}

enum Category:String {
	case latest
	case now_playing
	case popular
	case top_rated
	case upcoming
	case search
}

enum apiImg {
	enum backdrop_sizes {
		case w300
		case w400
		case w500
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

