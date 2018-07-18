//
//  IFSearchResponse.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import ObjectMapper

class IFSearchResponse: Mappable {

    var result : [IFElementModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["results"]
    }
}
