//
//  IFSearchService.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit

class IFSearchService: NSObject {

    let provider = IFSearchItunesProvider.singleton
    
    public func getSongs (_ request: IFSearchRequest, onSuccess: @escaping ([IFMusic]) -> Void, onFailure: @escaping (Error) -> Void) {
        
        self.provider.fetchMusic(for: request.query!, onSuccess:{ (response) in
            onSuccess(response)
        }) { (error) in
            print("Algo anduvo mal")
            onFailure(error)
        }
    }
    
    public func getTvShows (_ request: IFSearchRequest, onSuccess: @escaping ([IFTvShow]) -> Void, onFailure: @escaping (Error) -> Void) {
        
        self.provider.fetchMusic(for: "Muse", onSuccess:{ (response) in
            print("Algo anduvo bien")
        }) { (error) in
            print("Algo anduvo mal")
        }
    }
    
    public func getMovies (_ request: IFSearchRequest, onSuccess: @escaping ([IFMovie]) -> Void, onFailure: @escaping (Error) -> Void) {
        
        self.provider.fetchMusic(for: "Muse", onSuccess:{ (response) in
            print("Algo anduvo bien")
        }) { (error) in
            print("Algo anduvo mal")
        }
    }
}
