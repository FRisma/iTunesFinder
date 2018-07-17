//
//  IFLandingMainViewController.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import SnapKit

class IFLandingMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, IFLandingMainViewControllerProtocol {
    
    var currentSelectedCategory: Media = .music
    
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray) //TODO add a view with blur
    let actionSheetController: UIAlertController = UIAlertController(title: "Categories", message: "Option to select", preferredStyle: .actionSheet) //Consider replacing this with a segmented control
    
    let presenter = IFLandingMainViewPresenter()
    
    var elements: [IFBaseModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setupSearchController()
        self.setupTableView()
        self.setupFiltersOptions()
        self.setupLoadingIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setViewDelegate(view: self)
        self.applyConstraints()
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfElements = elements?.count {
            return numberOfElements
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IFElementViewCell
        
        let aSong = elements![indexPath.row] as! IFMusic
        cell.loadImage(fromURL: aSong.artWorkURL!)
        cell.title.text = aSong.song
        cell.subtitle.text = aSong.artist
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aSong = elements![indexPath.row] as! IFMusic
        self.presenter.rowTapped(selectedElement: aSong)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: This should be done in the presenter
        // Hide filter button while searching
        if searchController.isActive {
            searchController.searchBar.showsBookmarkButton = false
        } else {
            searchController.searchBar.showsBookmarkButton = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty && searchText.count > 3 {
            presenter.retrieveData(forText: searchText, andCategory: currentSelectedCategory)
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        //TODO this should be done in the presenter
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - IFLandingMainViewControllerProtocol
    
    func setPresenter(presenter: IFLandingMainViewPresenterProtocol) {
        print("SetteandoPresenter")
    }
    
    func updateView(withElements items: [IFBaseModel]) {
        elements = items
    }
    
    func showLoadingIndicator() {
        view.bringSubview(toFront: loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func goToDetailsViewController(forItem item: IFBaseModel) {
        if let playString = item.preview {
            let player = AVPlayer(url: URL(fileURLWithPath: playString))
            let vc = AVPlayerViewController()
            vc.player = player
            vc.showsPlaybackControls = true
            self.navigationController?.pushViewController(vc, animated: true)
            vc.player?.play()
        }
        /*IFDetails
         self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
         print("Toco una celda")*/
    }
    
    // MARK: - Iternal methods
    
    func setupNavBar() {
        navigationItem.title = "Busqueda"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        //searchController.searchBar.setImage(UIImage(named: "Sort"), for: .bookmark, state: .normal)
        searchController.obscuresBackgroundDuringPresentation = true
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(IFElementViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = self.searchController.searchBar
        
        view.addSubview(self.tableView)
    }
    
    func setupFiltersOptions() {
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let tvShowsActionButton = UIAlertAction(title: kTvShowMenuFilter, style: .default) { _ in
            self.currentSelectedCategory = .tvShow
        }
        actionSheetController.addAction(tvShowsActionButton)
        
        let musicActionButton = UIAlertAction(title: kMusicMenuFilter, style: .default) { _ in
            self.currentSelectedCategory = .music
        }
        actionSheetController.addAction(musicActionButton)
        
        let moviesActionButton = UIAlertAction(title: kMoviesMenuFilter, style: .default) { _ in
            self.currentSelectedCategory = .movie
        }
        actionSheetController.addAction(moviesActionButton)
    }
    
    func setupLoadingIndicator() {
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true;
        view.addSubview(loadingIndicator)
    }
    
    func applyConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}
