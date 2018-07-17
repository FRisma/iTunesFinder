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
    
    var resultsList = [Any]()
    
    init() {
        // Overriding initializer
    }
    
    public func retrieveData(forText term:String, andCategory category: Media) {
        
        let request = IFSearchRequest(query: term, category: category)
        
        switch category {
        case .movie:
            self.service.getMovies(request, onSuccess: { (response) in
                self.viewDelegate?.updateView(withElements: response)
            }) { (error) in
                //Actualizar la UI, algo salio mal
                print("Something went wrong")
            }
        case .music:
            self.service.getSongs(request, onSuccess: { (response) in
                self.viewDelegate?.updateView(withElements: response)
            }) { (error) in
                //Actualizar la UI, algo salio mal
                print("Something went wrong")
            }
            
        case .tvShow:
            self.service.getTvShows(request, onSuccess: { (response) in
                self.viewDelegate?.updateView(withElements: response)
            }) { (error) in
                //Actualizar la UI, algo salio mal
                print("Something went wrong")
            }
            
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
