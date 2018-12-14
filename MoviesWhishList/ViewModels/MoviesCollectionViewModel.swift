//
//  MoviesCollectionViewModel.swift
//  MoviesWhishList
//
//  Created by Jovan on 14/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation

protocol MoviesCollectionDelegate {
    func didRecieveMovies(movies: [MovieData])
    func didRecieveSearchResults(movies: [MovieData])
    func didRecieveMoviesError(error: TMDBError)
}

class MoviesCollectionViewModel {
    
    
    var loadingResults = false
    var currentPage = 0
    var totalOfPages = 0
    var totalOfMovies = 0
    var loadMovieType: MoviesListType = .popular
    
    var movies: [MovieData] = []
    
    var delegate: MoviesCollectionDelegate
    
    init(_ delegate: MoviesCollectionDelegate) {
        self.delegate = delegate
    }
    
    func loadMovies(loadType: MoviesListType, searchString: String?){
        
        if self.loadMovieType != loadType {
            currentPage = 0
            totalOfPages = 0
            totalOfMovies = 0
            loadingResults = false
            self.loadMovieType = loadType
        }
        
        if loadingResults || (currentPage > 0 && totalOfPages > 0 && currentPage >= totalOfPages) {
            debugPrint("[MoviesCollectionViewModel](loadMovies)  Não é possivel obter mais filmes \(loadingResults ? "pois está aguardando a resposta anterior" : "pois já chegou na última página")")
            return
        }
        
        currentPage += 1
        loadingResults = true

        
        
        if let searchQuery = searchString?.sanitized, loadType == .search, !searchQuery.isEmpty {
            debugPrint("[MoviesCollectionViewModel](Search) Página \(self.currentPage) solicitada")
            
            TMDB_API().searchMovie(withName: searchQuery,page: currentPage, success: { (info) in
                self.loadingResults = false
                if let tmdbInfo = info {
                    self.totalOfPages = tmdbInfo.totalPages
                    self.totalOfMovies = tmdbInfo.totalResults
                    debugPrint("[MoviesCollectionViewModel](Search) Total de Resultados: \(self.totalOfMovies) Total de Paginas: \(self.totalOfPages), Pagina Corrente: \(self.currentPage)")
                    self.movies += tmdbInfo.movies
                    self.delegate.didRecieveSearchResults(movies: tmdbInfo.movies)
                }
            }) { (error) in
                self.loadingResults = false
                self.resetLoad()
                self.delegate.didRecieveMoviesError(error: error!)
            }
        } else {
                debugPrint("[MoviesCollectionViewModel](PopularMovies) Página \(self.currentPage) solicitada")
            TMDB_API().loadMovies(page: self.currentPage, success: { (info) in
                self.loadingResults = false
                if let tmdbInfo = info {
                    self.totalOfPages = tmdbInfo.totalPages
                    self.totalOfMovies = tmdbInfo.totalResults
                    debugPrint("[MoviesCollectionViewModel](PopularMovies)  Total de Resultados: \(self.totalOfMovies) Total de Paginas: \(self.totalOfPages), Pagina Corrente: \(self.currentPage)")
                    self.movies += tmdbInfo.movies
                    self.delegate.didRecieveMovies(movies: tmdbInfo.movies)
                }
            }) { (error) in
                self.loadingResults = false
                self.resetLoad()
                debugPrint("[MoviesCollectionViewModel](PopularMovies) Error of Fetch Results for Popular Movies")
                self.delegate.didRecieveMoviesError(error: error!)
            }
        }
        

    }

     func resetLoad() {
        currentPage = 0
        totalOfPages = 0
        totalOfMovies = 0
        movies.removeAll()
    }
    
}
