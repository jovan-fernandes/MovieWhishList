//
//  StaredMovieTableViewCell.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import UIKit

class StaredMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var ivMoviePoster: UIImageView!
    
    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var lbMovieReleaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func prepare(with movie: StaredMovie) {
        lbMovieName.text = movie.title ?? ""
        lbMovieReleaseDate.text = movie.releaseDate ?? ""
        
        if let moviePoster = movie.posterPath {
            ivMoviePoster.kf.indicatorType = .activity
            ivMoviePoster.kf.setImage(with: TMDB_API.buildThumbnailUrl(for: moviePoster))
        } else {
            ivMoviePoster.image = nil
        }
    }

}
