//
//  TMDD_Config.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation


struct TMDBPath {
    
    static let API_PROTOCOL = "https"
    static let BASE_PATH = "api.themoviedb.org"
    static let API_VERSION = "/3"
    static let BASE_IMAGE_PATH = "image.tmdb.org"
    static let BASE_IMAGE_RESOURCE = "/t/p"
//    static let profileSizes = ["w45", "w185", "h632", "original"]
}


struct TMDBQueryParamKey {
    static let API_KEY = "api_key"
    static let API_PAGE = "page"
    static let API_LANGUAGE = "language"
    static let API_SEARCH = "query"
}

struct TMDBQueryParamValue {
    static let API_KEY = "d13dd0229b09605f9fd2349416337340"
    static let API_LANGUAGE = "pt-BR"
}

enum TMDBPosterSizes: String {
    case w92  = "/w92"
    case w154 = "/w154"
    case w185 = "/w185"
    case w342 = "/w342"
    case w500 = "/w500"
    case w700 = "/w780"
    case original = "/original"
}

enum TMDBApiResource: String {
    case movie = "/movie"
    case popularMovies = "/movie/popular"
    case topRatedMovies = "/movie/top_rated"
    case search = "/search/movie"
}
