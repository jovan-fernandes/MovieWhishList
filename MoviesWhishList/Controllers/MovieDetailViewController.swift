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
    
    let staredMoviesManager = StaredMoviesManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare(movie: movie)
        loadAditionalData()
    }
    
    func loadAditionalData() {
        TMDB_API().loadMovie(withId: movie!.id, success: { (movieDetail) in
            DispatchQueue.main.async {
                self.lbHomePage.text = movieDetail?.homepage
                self.lbGenres.text = ""
                for genre in (movieDetail?.genres)! {
                    self.lbGenres.text = self.lbGenres.text! + genre.name + " "
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.lbHomePage.text = ""
                self.lbGenres.text = ""
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
            (ivMoviePoster.kf.indicator?.view as? UIActivityIndicatorView)?.color = .red
            ivMoviePoster.kf.setImage(with: TMDB_API.buildThumbnailUrl(for: moviePoster, size: .w154))
        } else {
            ivMoviePoster.image = UIImage(named: "movie")
        }
    }
    

    @IBAction func btnFavoritar(_ sender: UIButton) {
        do {
            try staredMoviesManager.addStaredMovie(movie, context: context)
            navigationController?.popViewController(animated: true)
        } catch StaredMovieManagerError.alreadyExistsError(let e){
            showMessage(e)
        }catch {
            showErrorMessage("Ocorreu um erro ao favoritar")
            debugPrint("Erro ao favoritar ")
        }
    }
}
