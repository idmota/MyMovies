//
//  CommonsMenuModel.swift
//  MyMovies
//
//  Created by link on 12/4/20.
//

import UIKit


enum CommonsMenuModel: String {
	
	case now_playing
	case popular
	case top_rated
	case upcoming
	
	var name: String {
		switch self {
		case .now_playing:
			return "Menu.TodayInCinema".localized
		case .popular:
			return "Menu.Popular".localized
		case .top_rated:
			return "Menu.TopRated".localized
		case .upcoming:
			return "Menu.Upcoming".localized
		}
		
	}
	var exampleLink:String {
		switch self {
		case .now_playing:
			return "https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1"
		case .popular:
			return "https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1"
		case .top_rated:
			return "https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1"
		case .upcoming:
			return "https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1"
		}
	}
}
