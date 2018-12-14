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
private let footerViewReuseIdentifier = "RefreshFooterView"
private let acitivityIndicatorReuseIdentifier = "activityIndicatorCell"


enum MoviesListType: String {
    case popular = "popular"
    case search = "search"
}

class MoviesListCollectionViewController: UICollectionViewController {
    
    var activityIndicator: ActivityIndicatorFooterCollectionReusableView?
    
    var movieSelected: ((MovieData) -> ())? = { _ in }
    
 
    var searchText: String?
    var movieListType: MoviesListType = .popular
    
    var flowLayoutInitialSize: CGSize?
    var lbCollectionViewMessage = UILabel()
    
    var viewModel: MoviesCollectionViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureActivityIndicator()
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.bounces = true
        
        self.viewModel = MoviesCollectionViewModel(self)
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayoutInitialSize = flowLayout.itemSize
        
        showCollectionViewMessage(message: "Buscando filmes populares")
        
        loadMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("[MoviesListCollectionViewController](didReceiveMemoryWarning) Memory Warning!!!!!")
    }
    
    
    private func configureActivityIndicator() {
        self.collectionView.register(UINib(nibName: "ActivityIndicatorFooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        self.collectionView.register(UINib(nibName: "ActivityIndicatorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: acitivityIndicatorReuseIdentifier)
    }

    
    private func showCollectionViewMessage(message: String) {
        DispatchQueue.main.async {
            self.lbCollectionViewMessage.text = message
            self.lbCollectionViewMessage.textAlignment = .center
            self.lbCollectionViewMessage.textColor = UIColor.red
            self.lbCollectionViewMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.lbCollectionViewMessage.numberOfLines = 0;
            self.collectionView.backgroundView = self.lbCollectionViewMessage
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func clearColletionViewMessage(){
        DispatchQueue.main.async {
            self.lbCollectionViewMessage = UILabel()
            self.collectionView.backgroundView = nil
        }
    }
    
    func loadMovies() {
        viewModel.loadMovies(loadType: self.movieListType, searchString: searchText)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieDetailViewController
        let indexPaths = self.collectionView!.indexPathsForSelectedItems!
        let indexPath = indexPaths[0]
        vc.movie = viewModel.movies[indexPath.row]
    }
    
    // MARK: - Change FlowLayoutType
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
        return viewModel.movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        
        cell.prepareCell(with: viewModel.movies[indexPath.row])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieSelected?(viewModel.movies[indexPath.row])
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
        viewModel.resetLoad()
        searchText = nil
        loadMovies()
        searchBar.text = ""
        self.collectionView!.becomeFirstResponder()
        searchBar.endEditing(true)
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchQuery = searchBar.text, !searchQuery.isEmpty {
            viewModel.resetLoad()
            searchText = nil
            movieListType = .search
            self.showCollectionViewMessage(message: "Pesquisando.....")
            searchText = searchQuery
            loadMovies()
        }
    }
}


extension MoviesListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.loadingResults {
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

extension MoviesListCollectionViewController: MoviesCollectionDelegate {
    func didRecieveMovies(movies: [MovieData]) {
        DispatchQueue.main.async {
            self.clearColletionViewMessage()
            self.collectionView.reloadData()
        }
    }
    
    func didRecieveSearchResults(movies: [MovieData]) {
        if movies.isEmpty {
            self.showCollectionViewMessage(message: "Não foram encontrados resultados para a pesquisa")
        } else {
            self.clearColletionViewMessage()
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didRecieveMoviesError(error: TMDBError) {
        viewModel.resetLoad()
        searchText = nil
        self.showCollectionViewMessage(message: "Ops!! 😰😰😰😰😰😰😰")
    }

    
}
