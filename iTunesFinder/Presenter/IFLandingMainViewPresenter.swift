//
//  LandingMainViewPresenter.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

class IFLandingMainViewPresenter: IFLandingMainViewPresenterProtocol {
    
    private var viewDelegate: IFLandingMainViewControllerProtocol?
    private let service: IFSearchService!
    
    var currentSelectedCategory: Media! {
        didSet {
            self.viewDelegate?.updateView(withElements: [], forCategory: currentSelectedCategory)
        }
    }
    private var resultsList = [IFElementModel]()
    private var lastQueryTerm: String?

    // MARK: - Initializer
    init(witService service: IFSearchService) {
        self.service = service
    }
    
    // MARK: - IFLandingMainViewPresenterProtocol
    func setViewDelegate(view: IFLandingMainViewControllerProtocol) {
        viewDelegate = view
    }
    
    func rowTapped(selectedElement element:IFElementModel) {
        self.viewDelegate?.goToDetailsViewController(forItem: element)
    }
    
    public func retrieveData(forText term:String) {
        self.showActivityIndicator()
        
        let request = IFSearchRequest(query: term, category: currentSelectedCategory)
        lastQueryTerm = term;
        self.service.getData(request, onSuccess: { (response) in
            self.resultsList = response
            self.hideActivityIndicator()
            self.viewDelegate?.updateView(withElements: response, forCategory: request.category)
        }) { (error) in
            self.hideActivityIndicator()
            //TODO: Show error message as an alert
            print("Something went wrong")
        }
    }
    
    func switchedCategory(_ category: Media) {
        switch category {
        case .tvShow:
            currentSelectedCategory = .tvShow
            break
        case .music:
            currentSelectedCategory = .music
            break
        case .movie:
            currentSelectedCategory = .movie
        }
        
        if let term = lastQueryTerm {
            self.retrieveData(forText: term)
        }
    }
    
    // MARK: - Private Methods
    private func showActivityIndicator() {
        self.viewDelegate?.showLoadingIndicator()
    }
    
    private func hideActivityIndicator() {
        self.viewDelegate?.hideLoadingIndicator()
    }
    
}
