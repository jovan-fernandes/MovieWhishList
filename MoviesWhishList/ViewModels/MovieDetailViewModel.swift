//
//  MovieDetailViewModel.swift
//  MoviesWhishList
//
//  Created by Jovan on 14/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation


protocol MovieDetailDelegate {
    func didRecieveMovieData(movie: MovieDetail)
    func didRecieveMovieError(error: TMDBError)
}

class MoviesDetailViewModel {
    
    
    var delegate: MovieDetailDelegate
    
    init(_ delegate: MovieDetailDelegate) {
        self.delegate = delegate
    }
    
    
    func loadMovieData(id: Int){
        TMDB_API().loadMovie(withId: id, success: { (movieDetail) in
            self.delegate.didRecieveMovieData(movie: movieDetail!)
        }) { (error) in
            self.delegate.didRecieveMovieError(error: error!)
        }
    }
}
