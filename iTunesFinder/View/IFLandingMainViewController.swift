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

class IFLandingMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, IFLandingMainViewControllerProtocol {
    
    /*
     * Current displaying category
     */
    var displayCategory: Media! {
        didSet {
            switch displayCategory {
            case .tvShow:
                self.updateLayoutForTvShows()
            case .music:
                self.updateLayoutForMusic()
            case .movie:
                self.updateLayoutForMovies()
            default:
                fatalError("Media invalid or nil")
            }
        }
    }
    
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let sectionsControl = UISegmentedControl(items: [kTvShowMenuFilter,kMusicMenuFilter,kMoviesMenuFilter])
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray) //TODO add a view with blur
    
    let presenter: IFLandingMainViewPresenterProtocol!
    
    var elements: [IFElementModel]? {
        didSet {
            if elements != nil && elements!.count > 0 {
                isListEmpty = false
            } else {
                isListEmpty = true
            }
            tableView.reloadData()
        }
    }
    var isListEmpty = true
    
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
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = true;
        self.navigationController?.isToolbarHidden = true;
        
        self.setupSearchController()
        self.setupTableView()
        self.setupSegmentedControl()
        self.setupLoadingIndicator()
        
        presenter.setViewDelegate(view: self)
        // Set default to init to TvShow selected segment
        self.sectionsControl.selectedSegmentIndex = Media.tvShow.rawValue
        presenter.switchedCategory(Media(rawValue: sectionsControl.selectedSegmentIndex)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applyConstraints()
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfElements = elements?.count, numberOfElements > 0 {
            return numberOfElements
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isListEmpty {
            return self.cellForEmptyContent(forTable: tableView)
        } else {
            switch displayCategory {
            case .music:
                return self.cellForMusicElement(tableView: tableView, at: indexPath)
            case .movie:
                return self.cellForMovieElement(tableView: tableView, at: indexPath)
            case .tvShow:
                return self.cellForTvShowElement(tableView: tableView, at: indexPath)
            default:
                return self.cellForEmptyContent(forTable: tableView)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements![indexPath.row]
        self.presenter.rowTapped(selectedElement: element)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
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
    func updateView(withElements items: [IFElementModel], forCategory category: Media) {
        elements = items
        displayCategory = category
        self.searchController.isActive = false
    }
    
    func updateView(forCategory category: Media) {
        displayCategory = category
    }
    
    func showLoadingIndicator() {
        view.bringSubview(toFront: loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func goToDetailsViewController(forItem item: IFElementModel) {
        if let playString = item.preview {
            let player = AVPlayer(url: URL(fileURLWithPath: playString))
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            playerVC.showsPlaybackControls = true
            playerVC.allowsPictureInPicturePlayback = true
            playerVC.entersFullScreenWhenPlaybackBegins = true
            playerVC.exitsFullScreenWhenPlaybackEnds = true
            self.navigationController?.present(playerVC, animated: true, completion: {
                playerVC.player?.play()
            })
        }
    }
    
    // MARK: - Iternal methods
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = searchController.searchBar
        tableView.bounces = false
        tableView.register(IFMainMusicViewCell.self, forCellReuseIdentifier: "MusicCell")
        tableView.register(IFMainMovieViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.register(IFMainTvShowViewCell.self, forCellReuseIdentifier: "TvShowCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Error")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(self.tableView)
    }
    
    private func setupSegmentedControl() {
        sectionsControl.autoresizingMask = .flexibleWidth
        sectionsControl.frame = CGRect(x: 0, y: 0, width: 400, height: 30)
        sectionsControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        self.navigationItem.titleView = sectionsControl
    }

    @objc func changeSegment(_ sender: AnyObject) {
        presenter.switchedCategory(Media(rawValue: sectionsControl.selectedSegmentIndex)!)
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true;
        view.addSubview(loadingIndicator)
    }
    
    private func applyConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalTo(self.view)
            }
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    private func cellForMusicElement(tableView: UITableView,at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell") as! IFMainMusicViewCell
        tableView.separatorStyle = .none
        let aSong = elements![indexPath.row]
        cell.backgroundColor = .clear
        cell.loadImage(fromURL: aSong.artWorkURL!)
        cell.trackName.text    = aSong.trackName
        cell.artist.text       = aSong.artistName
        cell.selectionStyle    = .none
        
        return cell
    }
    
    private func cellForMovieElement(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! IFMainMovieViewCell
        
        let aMovie = elements![indexPath.row]
        cell.backgroundColor = .clear
        cell.loadImage(fromURL: aMovie.artWorkURL!)
        cell.title.text     = aMovie.artistName
        cell.brief.text     = aMovie.longDesc
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func cellForTvShowElement(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvShowCell") as! IFMainTvShowViewCell
        
        let aShow = elements![indexPath.row]
        cell.backgroundColor = .clear
        cell.loadImage(fromURL: aShow.artWorkURL!)
        cell.title.text     = aShow.artistName
        cell.episode.text   = aShow.trackName
        cell.brief.text     = aShow.longDesc
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func cellForEmptyContent(forTable table: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Error") {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = "No hay resultados para mostrar, por favor, intente nuevamente"
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            
            return cell
        }
        return UITableViewCell()
    }
    
    private func updateLayoutForTvShows() {
        sectionsControl.selectedSegmentIndex = Media.tvShow.rawValue
        navigationController?.navigationBar.barTintColor = Utils.UIColorFromRGB(rgbValue: kTvShowNavigationBarColor)
        //[self.tableView setBackgroundView:view];
        UIApplication.shared.statusBarStyle = .default
        self.view.backgroundColor = Utils.UIColorFromRGB(rgbValue: kTvShowBackgroundColor)
        searchController.searchBar.scopeBarBackgroundImage = UIImage.imageWithColor(color: Utils.UIColorFromRGB(rgbValue: kTvShowNavigationBarColor))
        self.view.setNeedsLayout()
    }
    
    private func updateLayoutForMusic() {
        sectionsControl.selectedSegmentIndex = Media.music.rawValue
        navigationController?.navigationBar.barTintColor = Utils.UIColorFromRGB(rgbValue: kMusicNavigationBarColor)
        UIApplication.shared.statusBarStyle = .lightContent
        self.view.backgroundColor = Utils.UIColorFromRGB(rgbValue: kMusicBackgroundColor)
        searchController.searchBar.scopeBarBackgroundImage = UIImage.imageWithColor(color: Utils.UIColorFromRGB(rgbValue: kMusicNavigationBarColor))
        self.view.setNeedsLayout()
    }
    
    private func updateLayoutForMovies() {
        sectionsControl.selectedSegmentIndex = Media.movie.rawValue
        navigationController?.navigationBar.barTintColor = Utils.UIColorFromRGB(rgbValue: kMoviesNavigationBarColor)
        UIApplication.shared.statusBarStyle = .default
        self.view.backgroundColor = Utils.UIColorFromRGB(rgbValue: kMoviesBackgroundColor)
        searchController.searchBar.scopeBarBackgroundImage = UIImage.imageWithColor(color: Utils.UIColorFromRGB(rgbValue: kMoviesNavigationBarColor))
        self.view.setNeedsLayout()
    }
}
