//
//  TMDB_API.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation
import Alamofire


class TMDB_API {
    

    
    static private let  MAX_PAGE_SIZE = 50
    
 
    
    typealias TMDB_Data = (TMDB_Info?) -> Void
    typealias MovieDetail_Data = (MovieDetail?) -> Void
    
    
    func loadMovies(page: Int = 1, callback: @escaping TMDB_Data) {
        Alamofire.request(self.buildMoviesURL(for: .popularMovies,
                                              withPathExtension: nil,
                                              addtionalParams: [TMDBQueryParamKey.API_PAGE: String(page)])).responseJSON { (res) in
            guard let data = res.data, res.response?.statusCode == 200 else {
                callback(nil)
                return
            }
            do {
                let tmdbInfo = try JSONDecoder().decode(TMDB_Info.self, from: data)
                callback(tmdbInfo)
            } catch {
                debugPrint("[TMDB_API](loadMovies)" + error.localizedDescription)
                callback(nil)
            }
            
        }
    }
    
    func loadMovie(withId movieId: Int, callback: @escaping MovieDetail_Data) {
        Alamofire.request(self.buildMoviesURL(for: .movie, withPathExtension: "/\(movieId)")).responseJSON { (res) in
            guard let data = res.data, res.response?.statusCode == 200 else {
                callback(nil)
                return
            }
            do {
                let movieDetailInfo = try JSONDecoder().decode(MovieDetail.self, from: data)
                callback(movieDetailInfo)
            } catch {
                debugPrint("[TMDB_API](loadMovie)" + error.localizedDescription)
                callback(nil)
            }
            
        }
    }
    
    
    func searchMovie(withName searchQuery: String, page: Int = 1,callback: @escaping TMDB_Data) {
        Alamofire.request(self.buildSearchUrl(withSearchQuery: searchQuery, addtionalParams: [TMDBQueryParamKey.API_PAGE: String(page)])).responseJSON { (res) in
            guard let data = res.data, res.response?.statusCode == 200 else {
                callback(nil)
                return
            }
            do {
                let tmdbInfo = try JSONDecoder().decode(TMDB_Info.self, from: data)
                callback(tmdbInfo)
            } catch {
                debugPrint("[TMDB_API](searchMovies)" + error.localizedDescription)
                callback(nil)
            }
            
        }
    }
    
    private func buildMoviesURL(for apiResource: TMDBApiResource, withPathExtension: String? = nil, addtionalParams: [String: String] = [:]) -> URLComponents {
        var url = URLComponents()
        url.scheme = TMDBPath.API_PROTOCOL
        url.host = TMDBPath.BASE_PATH
        url.path = TMDBPath.API_VERSION + apiResource.rawValue + (withPathExtension ?? "")
        
        url.queryItems = [URLQueryItem]()
        
        url.queryItems!.append(URLQueryItem(name: TMDBQueryParamKey.API_KEY, value: TMDBQueryParamValue.API_KEY))
        url.queryItems!.append(URLQueryItem(name: TMDBQueryParamKey.API_LANGUAGE, value: TMDBQueryParamValue.API_LANGUAGE))
        
        
        for (key, value) in addtionalParams {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            url.queryItems!.append(queryItem)
        }
        
        return url
    }
    
    func buildSearchUrl(withSearchQuery query: String, addtionalParams: [String: String] = [:]) -> URLComponents{
        var url = URLComponents()
        url.scheme = TMDBPath.API_PROTOCOL
        url.host = TMDBPath.BASE_PATH
        url.path = TMDBPath.API_VERSION + TMDBApiResource.search.rawValue
        
        url.queryItems = [URLQueryItem]()
        
        url.queryItems!.append(URLQueryItem(name: TMDBQueryParamKey.API_KEY, value: TMDBQueryParamValue.API_KEY))
        url.queryItems!.append(URLQueryItem(name: TMDBQueryParamKey.API_SEARCH, value: query))
        
        
        for (key, value) in addtionalParams {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            url.queryItems!.append(queryItem)
        }
        
        return url
    }
    
    class func buildThumbnailUrl(for imagePath: String, size posterSize: TMDBPosterSizes = .w92) -> URL{
        var url = URLComponents()
        url.scheme = TMDBPath.API_PROTOCOL
        url.host = TMDBPath.BASE_IMAGE_PATH
        url.path = TMDBPath.BASE_IMAGE_RESOURCE + posterSize.rawValue + imagePath
        return try! url.asURL()
    }
    
}
