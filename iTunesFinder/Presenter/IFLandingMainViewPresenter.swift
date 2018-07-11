//
//  LandingMainViewPresenter.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit

class IFLandingMainViewPresenter: NSObject {
    
    private let service = IFSearchService()
    
    public func start() {
        print("Arranca el presenter")
    }
    
    public func retrieveData() {
        self.service.getData()
    }

}
