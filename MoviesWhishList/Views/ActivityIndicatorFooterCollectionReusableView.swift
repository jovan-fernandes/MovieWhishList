//
//  ActivityIndicadorFooterView.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorFooterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var refreshControlIndicator: UIActivityIndicatorView!
    var currentTransform:CGAffineTransform?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareInitialAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
        if self.refreshControlIndicator.isAnimating {
            return
        }
        self.currentTransform = inTransform
        self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    
    //reset the animation
    func prepareInitialAnimation() {
        self.refreshControlIndicator?.stopAnimating()
        self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func startAnimate() {
        self.refreshControlIndicator?.startAnimating()
    }
    
    func stopAnimate() {
        self.refreshControlIndicator?.stopAnimating()
    }
    
    //final animation to display loading
    func animateFinal() {
        if self.refreshControlIndicator.isAnimating {
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.refreshControlIndicator?.transform = CGAffineTransform.identity
        }
    }
}
