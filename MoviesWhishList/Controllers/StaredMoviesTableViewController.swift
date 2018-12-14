//
//  StaredMoviesTableViewController.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import UIKit
import CoreData

private let reuseCellIdentifier = "staredMovieCell"

class StaredMoviesTableViewController: UITableViewController {

//    var fetchedResultController: NSFetchedResultsController<StaredMovie>!
    var lbTableMessage = UILabel()
    let staredMoviesManager = StaredMoviesManager.shared
    var staredMovies: [StaredMovie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbTableMessage.text = "Você não possui filmes favoritados"
        lbTableMessage.textAlignment = .center

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadStaredMovies()
        tableView.reloadData()
    }
    
    func loadStaredMovies() {
        do {
            self.staredMovies = try self.staredMoviesManager.loadStaredMovies(with: context)
        } catch {
            debugPrint("Error ->" + error.localizedDescription)
            showErrorMessage("Ocorreu um erro recuperar os filmes favoritados")
        }
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = staredMovies?.count ?? 0
        tableView.backgroundView = count == 0 ? lbTableMessage : nil
        
        return staredMovies?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as! StaredMovieTableViewCell

        guard let movie = staredMovies?[indexPath.row] else {
            return cell
        }

        cell.prepare(with: movie)
        
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let movie = staredMovies?[indexPath.row] else {return}
            context.delete(movie)
            loadStaredMovies()
            tableView.reloadData()
        }
    }

}

