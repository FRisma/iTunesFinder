//
//  IFLandingMainViewPresenterProtocol.swift
//  iTunesFinder
//
//  Created by Franco Risma on 16/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

protocol IFLandingMainViewPresenterProtocol {
    
    func setViewDelegate(view: IFLandingMainViewControllerProtocol)
    func rowTapped(selectedElement element:IFBaseModel)
    func switchedCategory(_ category:Media)
    func retrieveData(forText: String)
}
