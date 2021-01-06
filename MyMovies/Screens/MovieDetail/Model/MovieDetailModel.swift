//
//  MovieDetailModel.swift
//  MyMovies
//
//  Created by link on 11/19/20.
//

import Foundation
import UIKit

struct MovieDetailModel: Codable {
	let adult: Bool
	let backdropPath: String
	let belongsToCollection: BelongsToCollection?
	let budget: Int
	let genres: [Genre]
	let homepage: String
	let id: Int
	let imdbID:String?
	let originalLanguage, originalTitle, overview: String
	let popularity: Double
	let posterPath: String?
	let productionCompanies: [ProductionCompany]
	let productionCountries: [ProductionCountry]
	let releaseDate: String
	let revenue, runtime: Int
	let spokenLanguages: [SpokenLanguage]
	let status:Status
	let tagline, title: String
	let video: Bool
	let voteAverage: Double
	let voteCount: Int
	let videos: VideosS

	enum CodingKeys: String, CodingKey {
		case adult
		case backdropPath = "backdrop_path"
		case belongsToCollection = "belongs_to_collection"
		case budget, genres, homepage, id
		case imdbID = "imdb_id"
		case originalLanguage = "original_language"
		case originalTitle = "original_title"
		case overview, popularity
		case posterPath = "poster_path"
		case productionCompanies = "production_companies"
		case productionCountries = "production_countries"
		case releaseDate = "release_date"
		case revenue, runtime
		case spokenLanguages = "spoken_languages"
		case status, tagline, title, video
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
		case videos = "videos"
	}
}
enum Status: String, Codable {
	case Rumored
	case Planned
	case InProduction = "In Production"
	case Post
	case Production
	case Released = "Released"
	case Canceled
}
struct BelongsToCollection: Codable {
	let id: Int
	let name, posterPath, backdropPath: String

	enum CodingKeys: String, CodingKey {
		case id, name
		case posterPath = "poster_path"
		case backdropPath = "backdrop_path"
	}
}
// MARK: - Videos
struct VideosS: Codable {
	let results: [VideoModel]
	
}

// MARK: - Result
struct VideoModel: Codable {
	let id, iso639_1, iso3166_1, key: String
	let name, site: String
	let size: Int
	let type: String

	enum CodingKeys: String, CodingKey {
		case id
		case iso639_1 = "iso_639_1"
		case iso3166_1 = "iso_3166_1"
		case key, name, site, size, type
	}
}

// MARK: - Genre
struct Genre: Codable {
	let id: Int
	let name: String
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
	let id: Int
	let logoPath: String?
	let name, originCountry: String

	enum CodingKeys: String, CodingKey {
		case id
		case logoPath = "logo_path"
		case name
		case originCountry = "origin_country"
	}
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
	let iso3166_1, name: String

	enum CodingKeys: String, CodingKey {
		case iso3166_1 = "iso_3166_1"
		case name
	}
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
	let iso639_1, name: String

	enum CodingKeys: String, CodingKey {
		case iso639_1 = "iso_639_1"
		case name
	}
}


