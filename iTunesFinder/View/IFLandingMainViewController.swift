//
//  IFLandingMainViewController.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit

class IFLandingMainViewController: UIViewController {

    private let presenter = IFLandingMainViewPresenter()
    
    override func loadView() {
        presenter.start()
        // Set up presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.retrieveData()
        // Do any additional setup after loading the view.
    }

}
