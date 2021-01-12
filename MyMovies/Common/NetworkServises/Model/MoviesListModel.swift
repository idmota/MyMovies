//
//  MoviesListModel.swift
//  MyMovies
//
//  Created by link on 11/30/20.
//

import Foundation

struct MoviesListModel:Codable {
	let totalResults, page, totalPages: Int
	let movies: [MovieModel]
	
	enum CodingKeys: String, CodingKey {
		case totalResults = "total_results"
		case page
		case totalPages = "total_pages"
		case movies = "results"
	}
}

// MARK: - Result
struct MovieModel: Codable {
	let voteAverage, popularity: Double
	let voteCount: Int
	let releaseDate: String?
	let title: String
	let adult: Bool
	let backdropPath: String?
	let genreIDS: [Int]
//	let genresStr:String
	var genre: [MovieGenreModel] = []
	let overview: String
	let id: Int
	let originalTitle, originalLanguage: String
	let posterPath: String?
	let video: Bool
	
	enum CodingKeys: String, CodingKey {
		case voteAverage = "vote_average"
		case popularity
		case voteCount = "vote_count"
		case releaseDate = "release_date"
		case title, adult
		case backdropPath = "backdrop_path"
		case genreIDS = "genre_ids"
		case overview, id
		case originalTitle = "original_title"
		case posterPath = "poster_path"
		case originalLanguage = "original_language"
		case video
	}
}
