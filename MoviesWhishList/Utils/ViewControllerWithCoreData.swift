//
//  ViewControllerWithCoreData.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}

extension StaredMovie {
    
    convenience init(context: NSManagedObjectContext, movie: MovieData) {
        self.init(context: context)
        self.id = Int64(movie.id)
        self.title = movie.title
        self.originalLanguage = movie.originalLanguage
        self.originalTitle = movie.originalTitle
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
    }
}
