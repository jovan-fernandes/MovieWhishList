//
//  StaredMoviesManager.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation
import CoreData


class StaredMoviesManager {
 
    static let shared = StaredMoviesManager()
    
    var staredMovies: [StaredMovie] = []
    
    private init() {
    }
    
    func loadStaredMovies(with context: NSManagedObjectContext) {
        let fecthRequest: NSFetchRequest<StaredMovie> = StaredMovie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fecthRequest.sortDescriptors = [sortDescriptor]
        
        
        do{
            staredMovies = try context.fetch(fecthRequest)
        }catch {
            debugPrint("[StaredMoviesManager](loadStaredMovies) " + error.localizedDescription)
        }
    }
    
    func addStaredMovie(_ movie: MovieData, context: NSManagedObjectContext) {
        
    }
    
    func deleteStaredMovie(index: Int, context: NSManagedObjectContext) {
        let staredMovie = staredMovies[index]
        context.delete(staredMovie)
        do{
            try context.save()
        } catch {
            debugPrint("[StaredMoviesManager](deleteStaredMovie) " + error.localizedDescription)
        }
    }
}
