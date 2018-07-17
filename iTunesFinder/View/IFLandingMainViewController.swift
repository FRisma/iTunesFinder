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
    
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    
    let presenter = IFLandingMainViewPresenter()
    
    var elements: [Any]? {
        didSet {
            //Hide loading indicator
            tableView.reloadData()
        }
    }
    
    var elementsFiltered: [Any]?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        
        navigationItem.title = "Busqueda"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = true
        

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(IFElementViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.tableHeaderView = self.searchController.searchBar
        
        self.view.addSubview(self.tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applyConstraints()
        presenter.setViewDelegate(view: self)
    }
    
    // MARK: - Iternal methods
    
    func applyConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
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
        
        if let playString = aSong.preview {
            let player = AVPlayer(url: URL(fileURLWithPath: playString))
            let vc = AVPlayerViewController()
            vc.player = player
            self.navigationController?.pushViewController(vc, animated: true)
            vc.player?.play()
        }
        /*IFDetails
        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        print("Toco una celda")*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        //Perform search using the presenter if it has entered more than 3 chars
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty && searchText.count > 3 {
            //Show loading indicator
            presenter.retrieveData(forText: searchText, andCategory: .music)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    // MARK: - IFLandingMainViewControllerProtocol
    
    func setPresenter(presenter: IFLandingMainViewPresenterProtocol) {
        print("SetteandoPresenter")
    }
    
    func updateView(withElements items: [Any]) {
        elements = items
    }
}
