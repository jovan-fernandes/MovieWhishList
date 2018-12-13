//
//  MoviesListCollectionViewController.swift
//  MoviesWhishList
//
//  Created by Jovan on 11/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieCollectionViewCell"
private let reuseHeaderIdentifier = "CollectionViewHeader"

private let autoScrollIndex = 10

enum MoviesListType: String {
    case popular = "popular"
    case search = "search"
}

class MoviesListCollectionViewController: UICollectionViewController {
    
    
    var movies: [MovieData] = []
    var movieSelected: ((MovieData) -> ())? = { _ in }
    
    var loadingResults = false
    var currentPage = 0
    var totalOfPages = 0
    var totalOfMovies = 0
    var searchActive = false
    var searchText: String?
    var movieListType: MoviesListType = .popular
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

//        collectionView?.register(MovieCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }

    func loadMovies() {
        loadingResults = true
        currentPage += 1
        
        
        if let searchQuery = searchText, movieListType == .search{
            TMDB_API().searchMovie(withName: searchQuery) { (tmdbSearch) in
                if let tmdbInfo = tmdbSearch {
                    self.totalOfPages = tmdbInfo.totalPages
                    self.totalOfMovies = tmdbInfo.totalResults
                    self.movies += tmdbInfo.movies
                    debugPrint("[MoviesListCollectionViewController](Search)  Total de Paginas: \(self.totalOfPages), Pagina Corrente: \(self.currentPage)")
                    DispatchQueue.main.async {
                        self.loadingResults = false
                        self.collectionView.reloadData()
                    }
                }
            }
            
        } else {
            
            TMDB_API().loadMovies(page: currentPage) { (tmdbInfo) in
                if let tmdbInfo = tmdbInfo {
                    self.totalOfPages = tmdbInfo.totalPages
                    self.totalOfMovies = tmdbInfo.totalResults
                    self.movies += tmdbInfo.movies
                    debugPrint("[MoviesListCollectionViewController](LoadingMovies) Total de Paginas: \(self.totalOfPages), Pagina Corrente: \(self.currentPage)")
                    DispatchQueue.main.async {
                        self.loadingResults = false
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    fileprivate func clearSearchFlags() {
        movies = []
        currentPage = 0
        totalOfPages = 0
        totalOfMovies = 0
        searchText = nil
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieDetailViewController
        let indexPaths = self.collectionView!.indexPathsForSelectedItems!
        let indexPath = indexPaths[0]
        vc.movie = movies[indexPath.row]
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
    
        let movie = movies[indexPath.row]
        cell.prepareCell(with: movie)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieSelected?(movies[indexPath.row])
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - autoScrollIndex && !loadingResults && currentPage != totalOfPages{
            loadMovies()
            debugPrint("[MoviesListCollectionViewController] Carregando mais filmes. Atualmente Movies \(movies.count) de \(totalOfMovies)")
        }
    }

}


extension MoviesListCollectionViewController: UISearchBarDelegate {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath)
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("[MoviesListCollectionVIewController](searchBarCancelButtonClicked)")
        movieListType = .popular
        clearSearchFlags()
        loadMovies()
        searchBar.text = ""
        self.collectionView!.becomeFirstResponder()
        searchBar.endEditing(true)
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchQuery = searchBar.text, !searchQuery.isEmpty {
            clearSearchFlags()
            movieListType = .search
            searchText = searchQuery
            loadMovies()
        }
    }
    
    
}
