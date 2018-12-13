//
//  MovieCollectionViewCell.swift
//  MoviesWhishList
//
//  Created by Jovan on 11/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivMoviePoster: UIImageView!
    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var lbRelease: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate let formatter = DateFormatter(pattern: DateUtils.defaultDatePattern)
    
    func prepareCell(with movie: MovieData) {
        lbMovieName.text = movie.title
        lbRelease.text = movie.releaseDate
        if let moviePoster = movie.posterPath {
            ivMoviePoster.kf.indicatorType = .activity
            ivMoviePoster.kf.setImage(with: TMDB_API.buildThumbnailUrl(for: moviePoster))
        } else {
            ivMoviePoster.image = nil
        }
        ivMoviePoster.layer.borderColor = UIColor.gray.cgColor
        ivMoviePoster.layer.borderWidth = 1
        
    }
}
