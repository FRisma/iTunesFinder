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
    
    public func getData(_ request: IFSearchRequest, onSuccess: @escaping ([IFBaseModel]) -> Void, onFailure: @escaping (Error) -> Void) {
        
        self.provider.fetchInfo(request, onSuccess:{ (response) in
            onSuccess(response)
        }) { (error) in
            print("Algo anduvo mal")
            onFailure(error)
        }
    }
}
