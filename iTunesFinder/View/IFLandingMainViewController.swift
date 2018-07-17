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
    
    var displayCategory: Media!
    
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray) //TODO add a view with blur
    
    let presenter: IFLandingMainViewPresenterProtocol!
    
    var elements: [IFBaseModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Initializer
    init(withPresenter presenter: IFLandingMainViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setupSearchController()
        self.setupTableView()
        //self.setupFiltersOptions()
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
        
        /*switch displayCategory {
        case .music:
            self.cellForMusicElement()
            break
        case .movie:
            break
        case .tvShow:
            break
        default:
        
        }*/
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IFMainMusicViewCell
        
        let aSong = elements![indexPath.row] as! IFMusic
        cell.loadImage(fromURL: aSong.artWorkURL!)
        cell.title.text = aSong.getSong()
        cell.subtitle.text = aSong.getArtist()
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
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            //searchBar. disable search button if text is empty
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            presenter.retrieveData(forText: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        presenter.switchedCategory(Media(rawValue: selectedScope)!)
    }
    
    // MARK: - IFLandingMainViewControllerProtocol
    
    func setPresenter(presenter: IFLandingMainViewPresenterProtocol) {
        print("SetteandoPresenter")
    }
    
    func updateView(withElements items: [IFBaseModel], forCategory category: Media) {
        displayCategory = category
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
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = [kTvShowMenuFilter.capitalized,
                                                        kMusicMenuFilter.capitalized,
                                                        kMoviesMenuFilter.capitalized]
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(IFMainMusicViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = self.searchController.searchBar
        
        view.addSubview(self.tableView)
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
    
    func cellForMusicElement() {
        
    }
    
    func cellForMovieElement() {
        
    }
    
    func cellForTvShowElement() {
        
    }
    
    func cellForNoElement() {
        
    }
}
