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
    
    //var isInTheMiddleOfSearch = false
    var resultsList = [Any]()
    
    init() {
        // Overriding initializer
    }
    
    public func retrieveData(forText term:String, andCategory category: Media) {
        //isInTheMiddleOfSearch = true
        self.showActivityIndicator()
        
        let request = IFSearchRequest(query: term, category: category)
        
        switch category {
        case .movie:
            self.service.getMovies(request, onSuccess: { (response) in
                //self.isInTheMiddleOfSearch = false
                self.hideActivityIndicator()
                self.viewDelegate?.updateView(withElements: response)
            }) { (error) in
                //Actualizar la UI, algo salio mal
                print("Something went wrong")
                //self.isInTheMiddleOfSearch = false
                self.hideActivityIndicator()
            }
        case .music:
            self.service.getSongs(request, onSuccess: { (response) in
                //self.isInTheMiddleOfSearch = false
                self.hideActivityIndicator()
                self.viewDelegate?.updateView(withElements: response)
            }) { (error) in
                //Actualizar la UI, algo salio mal
                //self.isInTheMiddleOfSearch = false
                self.hideActivityIndicator()
                print("Something went wrong")
            }
            
        case .tvShow:
            self.service.getTvShows(request, onSuccess: { (response) in
                //self.isInTheMiddleOfSearch = false
                self.hideActivityIndicator()
                self.viewDelegate?.updateView(withElements: response)
            }) { (error) in
                //Actualizar la UI, algo salio mal
                //self.isInTheMiddleOfSearch = false
                self.hideActivityIndicator()
                print("Something went wrong")
            }
        }
    }
    
    // MARK: - IFLandingMainViewPresenterProtocol
    
    func setViewDelegate(view: IFLandingMainViewControllerProtocol) {
        viewDelegate = view
    }
    
    func rowTapped(selectedElement element:IFBaseModel) {
        self.viewDelegate?.goToDetailsViewController(forItem: element)
    }
    
    // MARK: - Private Methods
    func showActivityIndicator() {
        self.viewDelegate?.showLoadingIndicator()
    }
    
    func hideActivityIndicator() {
        //if !isInTheMiddleOfSearch {
            self.viewDelegate?.hideLoadingIndicator()
        //}
    }
    
}
