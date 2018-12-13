//
//  MovieVO.swift
//  MoviesWhishList
//
//  Created by Jovan on 11/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation

struct TMDB_Info : Codable {
    let currentPage: Int
    let totalResults: Int
    let totalPages: Int
    let movies: [MovieData]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}

struct MovieData: Codable {
    
    let id: Int
    let title: String
    let originalTitle: String
    let releaseDate: String?
    let originalLanguage: String
    let posterPath: String?
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case overview = "overview"
    }

}


struct MovieDetail: Codable {
    
    let id: Int
    let title: String
    let originalTitle: String
    let releaseDate: String?
    let originalLanguage: String
    let posterPath: String?
    let overview: String
    let homepage: String?
    let genres: [MovieGenre]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case overview = "overview"
        case homepage = "homepage"
        case genres = "genres"
    }
    
    
}

struct MovieGenre: Codable {
    let id: Int
    let name: String
}
