//
//  LandingMainViewPresenter.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

class IFLandingMainViewPresenter: IFLandingMainViewPresenterProtocol {
    var viewDelegate: IFLandingMainViewControllerProtocol?
    let service = IFSearchService()
    
    init() {
        // Overriding initializer
    }
    
    public func retrieveData() {
        
        let request = IFSearchRequest(query: "Muse", category: .music)
        self.service.getSongs(request, onSuccess: { (response) in
            //Actualizar la UI, algo salio BIEN
            print("Something went well")
            
            self.viewDelegate?.updateView(withElements: response)
            
            
        }) { (error) in
            //Actualizar la UI, algo salio mal
            print("Something went wrong")
        }
    }
    
    // MARK: - IFLandingMainViewPresenterProtocol
    
    func setViewDelegate(view: IFLandingMainViewControllerProtocol) {
        viewDelegate = view
    }
    
    func searchButtonTapped() {
        print("ButtonTapped")
    }
    
    func rowTapped() {
        print("RowTapped")
    }
    
}
