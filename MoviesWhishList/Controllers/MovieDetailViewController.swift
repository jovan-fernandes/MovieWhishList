//
//  MovieDetailViewController.swift
//  MoviesWhishList
//
//  Created by Jovan on 12/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: MovieData!

    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var ivMoviePoster: UIImageView!
    @IBOutlet weak var biMovieTitle: UINavigationItem!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var tvOverview: UITextView!
    @IBOutlet weak var lbHomePage: UILabel!
    @IBOutlet weak var lbGenres: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare(movie: movie)
        loadAditionalData()
    }
    
    func loadAditionalData() {
        TMDB_API().loadMovie(withId: movie!.id) { (movieDetail) in
            DispatchQueue.main.async {
                self.lbHomePage.text = movieDetail?.homepage
                self.lbGenres.text = ""
                for genre in (movieDetail?.genres)! {
                    self.lbGenres.text = self.lbGenres.text! + genre.name + " "
                }
            }
        }
    }
    
    
    func prepare(movie: MovieData) {
        biMovieTitle.title = movie.originalTitle
        lbMovieName.text = movie.title
        lbReleaseDate.text = movie.releaseDate
        tvOverview.text = movie.overview
        lbHomePage.text = ""
        lbGenres.text = ""
        if let moviePoster = movie.posterPath {
            ivMoviePoster.kf.indicatorType = .activity
            ivMoviePoster.kf.setImage(with: TMDB_API.buildThumbnailUrl(for: moviePoster, size: .w154))
        } else {
            ivMoviePoster.image = nil
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnFavoritar(_ sender: UIButton) {
    
    }
}