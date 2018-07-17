//
//  IFLandingMainViewControllerProtocol.swift
//  iTunesFinder
//
//  Created by Franco Risma on 16/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

protocol IFLandingMainViewControllerProtocol {
    
    func setPresenter(presenter :IFLandingMainViewPresenterProtocol)
    func updateView(withElements items: [IFBaseModel], forCategory category: Media)
    func goToDetailsViewController(forItem item: IFBaseModel)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
}
