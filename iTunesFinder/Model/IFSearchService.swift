//
//  IFSearchService.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit

class IFSearchService: NSObject {

    private let provider = IFSearchItunesProvider()
    
    public func getData() -> Void {
        
        self.provider.fetchData(onSuccess: { (response) in
            print(response);
        }) { (error) in
            print(error);
        }
    }
}
