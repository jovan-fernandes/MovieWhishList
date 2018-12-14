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
    
    var viewModel: MoviesDetailViewModel!
    
    
    fileprivate func addUrlAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MovieDetailViewController.openHomePage))
        lbHomePage.isUserInteractionEnabled = true
        lbHomePage.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MoviesDetailViewModel(self)
        prepare(movie: movie)
        
        loadAditionalData()
    }
    
    
    @objc func openHomePage(){
        if let url = URL(string: self.lbHomePage.text!) {
            UIApplication.shared.open(url, options: [:])
            
              //Caso fosse video do youtube:
//            let youtubeId = "xxxxxxxxxx"
//            var url = URL(string:"youtube://\(youtubeId)")!
//            if !UIApplication.shared.canOpenURL(url)  {
//                url = URL(string:"http://www.youtube.com/watch?v=\(youtubeId)")!
//            }else{
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }

          
           
        }
    }
    
    func loadAditionalData() {
        viewModel.loadMovieData(id: movie.id)
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

extension MovieDetailViewController: MovieDetailDelegate {
    func didRecieveMovieData(movie: MovieDetail) {
        DispatchQueue.main.async {
            if let hp = movie.homepage {
                self.lbHomePage.text = hp
                self.addUrlAction()
            }else{
                self.lbHomePage.text = ""
            }
            self.lbGenres.text = ""
            for genre in (movie.genres)! {
                self.lbGenres.text = self.lbGenres.text! + genre.name + " "
            }
        }
    }
    
    func didRecieveMovieError(error: TMDBError) {
        DispatchQueue.main.async {
            self.lbHomePage.text = ""
            self.lbGenres.text = ""
        }
    }
    

    
}
