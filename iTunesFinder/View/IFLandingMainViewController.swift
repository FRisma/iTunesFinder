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
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.tableFooterView = UIView(frame: .zero)
        tv.tableHeaderView = searchController.searchBar
        tv.bounces = false
        tv.register(IFMainMusicViewCell.self, forCellReuseIdentifier: "MusicCell")
        tv.register(IFMainMovieViewCell.self, forCellReuseIdentifier: "MovieCell")
        tv.register(IFMainTvShowViewCell.self, forCellReuseIdentifier: "TvShowCell")
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Error")
        tv.showsHorizontalScrollIndicator = false
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = true
        sc.hidesNavigationBarDuringPresentation = false;
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.showsScopeBar = false
        sc.searchBar.backgroundColor = .clear
        return sc
    }()
    
    let sectionsControl = UISegmentedControl(items: [kTvShowMenuFilter,kMusicMenuFilter,kMoviesMenuFilter])
    let loadingIndicator = IFLoadingIndicatorView.singleton
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1.0
        }
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
        self.view.addSubview(loadingIndicator)
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.removeFromSuperview()
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
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
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
        cell.title.text     = aMovie.trackName
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
            cell.textLabel?.text = "No hay resultados para mostrar, por favor intente nuevamente."
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            
            var fontColor: UIColor = .black
            switch displayCategory {
            case .music:
                fontColor = UIColor.init(fromRGBValue:kMusicFontColor)
            case .movie:
                fontColor = UIColor.init(fromRGBValue:kMoviesFontColor)
            case .tvShow:
                fontColor = UIColor.init(fromRGBValue:kTvShowFontColor)
            default:
                fontColor = .black
            }
            cell.textLabel?.textColor = fontColor
            return cell
        }
        return UITableViewCell()
    }
    
    private func updateLayoutForTvShows() {
        sectionsControl.selectedSegmentIndex = Media.tvShow.rawValue
        self.updateUI(segmentColor: UIColor.init(fromRGBValue: kTvShowFontColor),
                      navBarTintColor: UIColor.init(fromRGBValue:kTvShowNavigationBarColor),
                      statusBarStyle: .default,
                      viewBackgroundColor: UIColor.init(fromRGBValue:kTvShowBackgroundColor),
                      andSearchBarColor: UIColor.init(fromRGBValue:kTvShowFontColor))
    }
    
    private func updateLayoutForMusic() {
        sectionsControl.selectedSegmentIndex = Media.music.rawValue
        self.updateUI(segmentColor: UIColor.init(fromRGBValue:kMusicFontColor),
                      navBarTintColor: UIColor.init(fromRGBValue:kMusicNavigationBarColor),
                      statusBarStyle: .lightContent,
                      viewBackgroundColor: UIColor.init(fromRGBValue:kMusicBackgroundColor),
                      andSearchBarColor: UIColor.init(fromRGBValue:kMusicFontColor))
    }
    
    private func updateLayoutForMovies() {
        sectionsControl.selectedSegmentIndex = Media.movie.rawValue
        self.updateUI(segmentColor: UIColor.init(fromRGBValue:kMoviesFontColor),
                      navBarTintColor: UIColor.init(fromRGBValue:kMoviesNavigationBarColor),
                      statusBarStyle: .default,
                      viewBackgroundColor: UIColor.init(fromRGBValue:kMoviesBackgroundColor),
                      andSearchBarColor: UIColor.init(fromRGBValue:kMoviesFontColor))
    }
    
    private func updateUI(segmentColor: UIColor, navBarTintColor: UIColor, statusBarStyle: UIStatusBarStyle, viewBackgroundColor: UIColor, andSearchBarColor searchBarColor: UIColor) {
        sectionsControl.tintColor = segmentColor
        navigationController?.navigationBar.barTintColor = navBarTintColor
        UIApplication.shared.statusBarStyle = statusBarStyle
        self.view.backgroundColor = viewBackgroundColor
        searchController.searchBar.scopeBarBackgroundImage = UIImage.imageWithColor(color: navBarTintColor)
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = searchBarColor
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = searchBarColor
        tableView.separatorColor = segmentColor
        self.view.setNeedsLayout()
    }
}
