//
//  StaredMoviesManager.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation
import CoreData

enum StaredMovieManagerError: Error {
    case coreDataError(String)
    case alreadyExistsError(String)
}

class StaredMoviesManager {
 
    static let shared = StaredMoviesManager()
    
    var staredMovies: [StaredMovie] = []
    
    private init() {
    }
    
    func loadStaredMovies(with context: NSManagedObjectContext) throws -> [StaredMovie]{
        let fecthRequest: NSFetchRequest<StaredMovie> = StaredMovie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fecthRequest.sortDescriptors = [sortDescriptor]
        
        
        do{
           return try context.fetch(fecthRequest)
        }catch {
            debugPrint("[StaredMoviesManager](loadStaredMovies) " + error.localizedDescription)
            throw StaredMovieManagerError.coreDataError("Não foi possível consultar os filmes favoritados")
        }
    }
    
    fileprivate func getStaredMovieBy(id id: Int,_ context: NSManagedObjectContext) throws -> [StaredMovie] {
        do{
            let fecthRequest: NSFetchRequest<StaredMovie> = StaredMovie.fetchRequest()
            let predicate = NSPredicate(format: "id == %i", Int64(id))
            fecthRequest.predicate = predicate
            return  try context.fetch(fecthRequest)
        } catch {
            debugPrint("[StaredMoviesManager](addStaredMovie) " + error.localizedDescription)
            throw StaredMovieManagerError.coreDataError("Problema ao salvar filme favorito")
        }
    }
    
    func addStaredMovie(_ movie: MovieData, context: NSManagedObjectContext) throws {
        var result: [StaredMovie] = []
        do {
            result = try getStaredMovieBy(id: movie.id, context)
        } catch {
            debugPrint("[StaredMoviesManager](addStaredMovie) " + error.localizedDescription)
            throw StaredMovieManagerError.coreDataError("Problema ao salvar filme favorito")
        }
        
        
        if !result.isEmpty {
            throw StaredMovieManagerError.alreadyExistsError("O Filme já foi favoritado")
        }
        
        do{
            let _ = StaredMovie(context: context, movie: movie)
            try context.save()
        }catch{
            debugPrint("[StaredMoviesManager](addStaredMovie) " + error.localizedDescription)
            throw StaredMovieManagerError.coreDataError("Problema ao salvar filme favorito")
        }
    }
    
    func deleteStaredMovie(index: Int, context: NSManagedObjectContext) throws {
        let staredMovie = staredMovies[index]
        context.delete(staredMovie)
        do{
            try context.save()
        } catch {
            debugPrint("[StaredMoviesManager](deleteStaredMovie) " + error.localizedDescription)
            throw StaredMovieManagerError.coreDataError("Problema ao excluir filme favorito")
        }
    }
}
