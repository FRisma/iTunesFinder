//
//  IFSearchItunesProvider.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit
import Alamofire

class IFSearchItunesProvider {
    
    static let singleton = IFSearchItunesProvider()
    
    private init() {
    }
    
    func fetchInfo(_ request: IFSearchRequest, onSuccess:@escaping ([IFElementModel]) -> Void, onFailure:@escaping (Error) -> Void ) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(API_URL,
                          method: .get,
                          parameters: ["term": request.query ?? "", "media": request.category.description])
            .validate()
            .responseString() { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch(response.result) {
                case .success (let responseString):
                    if let dataResponse = IFSearchResponse(JSONString: "\(responseString)") {
                        if let objects = dataResponse.result {
                            if objects.isEmpty {
                                onSuccess([])
                            } else {
                                onSuccess(dataResponse.result!)
                            }
                        } else {
                            onSuccess([])
                        }
                    }
                case .failure(let error):
                    print(error)
                    onFailure(error)
                }
        }
    }
}
