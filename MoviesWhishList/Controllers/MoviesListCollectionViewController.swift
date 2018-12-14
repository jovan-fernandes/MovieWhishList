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
    
    var activityIndicator: ActivityIndicatorFooterCollectionReusableView?
    let footerViewReuseIdentifier = "RefreshFooterView"
    let acitivityIndicatorReuseIdentifier = "activityIndicatorCell"
    
    var movies: [MovieData] = []
    var movieSelected: ((MovieData) -> ())? = { _ in }
    
    var loadingResults = false
    var currentPage = 0
    var totalOfPages = 0
    var totalOfMovies = 0
    var searchActive = false
    var searchText: String?
    var movieListType: MoviesListType = .popular
    
    var flowLayoutInitialSize: CGSize?
    var lbCollectionViewMessage = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "ActivityIndicatorFooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        self.collectionView.register(UINib(nibName: "ActivityIndicatorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: acitivityIndicatorReuseIdentifier)
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.bounces = true
        
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayoutInitialSize = flowLayout.itemSize
        
        showCollectionViewMessage(message: "Buscando filmes populares")
        loadMovies()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("[MoviesListCollectionViewController](didReceiveMemoryWarning) Memory Warning!!!!!")
    }
    
    fileprivate func showCollectionViewMessage(message: String) {
        DispatchQueue.main.async {
            self.lbCollectionViewMessage.text = message
            self.lbCollectionViewMessage.textAlignment = .center
            self.lbCollectionViewMessage.textColor = UIColor.red
            self.lbCollectionViewMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.lbCollectionViewMessage.numberOfLines = 0;
            self.collectionView.backgroundView = self.lbCollectionViewMessage
        }
    }
    
    fileprivate func clearColletionViewMessage(){
        DispatchQueue.main.async {
            self.lbCollectionViewMessage = UILabel()
            self.collectionView.backgroundView = nil
        }
    }
    
    func loadMovies() {

        if loadingResults || (currentPage > 0 && totalOfPages > 0 && currentPage >= totalOfPages) {
            debugPrint("[MoviesListCollectionViewController](loadMovies)  Não é possivel obter mais filmes \(loadingResults ? "pois está aguardando a resposta anterior" : "pois já chegou na última página")")
            return
        }
        
        
        currentPage += 1
        loadingResults = true
        
        if let searchQuery = searchText, movieListType == .search, !searchQuery.isEmpty {
              debugPrint("[MoviesListCollectionViewController](Search) Página \(self.currentPage) solicitada")
            TMDB_API().searchMovie(withName: searchQuery.sanitized, success:         { (tmdbSearch) in
                if let tmdbInfo = tmdbSearch {
                    self.totalOfPages = tmdbInfo.totalPages
                    self.totalOfMovies = tmdbInfo.totalResults
                    self.movies += tmdbInfo.movies
                    debugPrint("[MoviesListCollectionViewController](Search) Total de Resultados: \(self.totalOfMovies) Total de Paginas: \(self.totalOfPages), Pagina Corrente: \(self.currentPage)")
                    self.loadingResults = false
                    if self.totalOfMovies <= 0 {
                        self.showCollectionViewMessage(message: "Não foram encontrados resultados para a pesquisa")
                    } else {
                        self.clearColletionViewMessage()
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }) { (error) in
                debugPrint("[MoviesListCollectionViewController](Search)  Error on Fetch Seach results \(String(describing: error))")
                self.loadingResults = false
                self.clearSearchFlags()
                self.showCollectionViewMessage(message: "Ops!! 😰😰😰😰😰😰😰")
            }
            
        } else {
            debugPrint("[MoviesListCollectionViewController](PopularMovies) Página \(self.currentPage) solicitada")
            TMDB_API().loadMovies(page: currentPage, success: { (tmdbInfo) in
                if let tmdbInfo = tmdbInfo {
                    self.totalOfPages = tmdbInfo.totalPages
                    self.totalOfMovies = tmdbInfo.totalResults
                    self.movies += tmdbInfo.movies
                    debugPrint("[MoviesListCollectionViewController](PopularMovies)  Total de Resultados: \(self.totalOfMovies) Total de Paginas: \(self.totalOfPages), Pagina Corrente: \(self.currentPage)")
                    DispatchQueue.main.async {
                        self.loadingResults = false
                        self.clearColletionViewMessage()
                        self.collectionView.reloadData()
                    }
                }
            }) { (error) in
               debugPrint("[MoviesListCollectionViewController](PopularMovies) Error of Fetch Results for Popular Movies")
                self.clearSearchFlags()
                self.loadingResults = false
                DispatchQueue.main.async {
                    self.showCollectionViewMessage(message: "Ops!! 😰😰😰😰😰😰😰")
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    fileprivate func clearSearchFlags() {
        movies.removeAll()
        currentPage = 0
        totalOfPages = 0
        totalOfMovies = 0
        searchText = nil
        DispatchQueue.main.async {
            self.collectionView.backgroundView = nil
            self.collectionView.reloadData()
        }
    }
    
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieDetailViewController
        let indexPaths = self.collectionView!.indexPathsForSelectedItems!
        let indexPath = indexPaths[0]
        vc.movie = movies[indexPath.row]
    }
    
    @IBAction func changeLayout(_ sender: UIBarButtonItem) {
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if(flowLayout.itemSize.height > (flowLayoutInitialSize?.height)!){
            flowLayout.itemSize = flowLayoutInitialSize!
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "list")
        } else {
            flowLayout.itemSize = CGSize(width: (flowLayoutInitialSize?.width)! * 2, height: (flowLayoutInitialSize?.height)! * 2)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "grid")
        }
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
//        if indexPath.row == movies.count - autoScrollIndex && !loadingResults && currentPage != totalOfPages{
//            loadMovies()
//            debugPrint("[MoviesListCollectionViewController] Carregando mais filmes. Atualmente Movies \(movies.count) de \(totalOfMovies)")
//        }
    }

}


extension MoviesListCollectionViewController: UISearchBarDelegate {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case  UICollectionView.elementKindSectionHeader:
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath)
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! ActivityIndicatorFooterCollectionReusableView
            self.activityIndicator = footerView
            self.activityIndicator?.backgroundColor = UIColor.clear
            return footerView
        default:
            return UICollectionReusableView()
        }
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
            self.showCollectionViewMessage(message: "Pesquisando.....")
            searchText = searchQuery
            loadMovies()
        }
    }
}


extension MoviesListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if loadingResults {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
}

// MARK: ActivityIndicator Control
extension MoviesListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.activityIndicator?.prepareInitialAnimation()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.activityIndicator?.stopAnimate()
        }
    }
}


// MARK: ScrollViewControl
extension MoviesListCollectionViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.activityIndicator?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.activityIndicator?.animateFinal()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //workaround for devices with notch
        //TODO: verificar maneira de controlar dinamicamente
        let deviceOffset = OsUtils.deviceHasNotch() ? CGFloat(83.0) : CGFloat(49.0)
        
        
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height + deviceOffset;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        debugPrint(" [MoviesListCollectionVIewController](scrollViewDidEndDecelerating) Device hasNotch: \(OsUtils.deviceHasNotch())  -> Pull Heigth: \(pullHeight) frameHeight: \(frameHeight) deviceOffset \(deviceOffset) contentHeight \(contentHeight) contentOffset \(contentOffset)")
        if pullHeight == 0.0
        {
                debugPrint("[MoviesListCollectionVIewController](scrollViewDidEndDecelerating) load more movies trigger")
                self.activityIndicator?.startAnimate()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                    self.loadMovies()
                })
        }
    }
}
