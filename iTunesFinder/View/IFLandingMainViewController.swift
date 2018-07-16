//
//  IFLandingMainViewController.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class IFLandingMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IFLandingMainViewControllerProtocol {
    
    let tableView = UITableView()
    
    let presenter = IFLandingMainViewPresenter()
    let searchController = UISearchController(searchResultsController: nil)
    
    var elements: [Any]? {
        didSet {
            tableView.reloadData()
        }
    }
    var imageURLArray: Array<String> = []
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IFElementViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applyConstraints()
        presenter.setViewDelegate(view: self)
        presenter.retrieveData()
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Toco una celda")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - IFLandingMainViewControllerProtocol
    
    func setPresenter(presenter: IFLandingMainViewPresenterProtocol) {
        print("SetteandoPresenter")
    }
    
    func updateView(withElements items: [Any]) {
        elements = items
    }
}
