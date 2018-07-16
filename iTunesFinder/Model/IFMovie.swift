//
//  IFMovie.swift
//  iTunesFinder
//
//  Created by Franco Risma on 13/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import ObjectMapper

class IFMovie: IFBaseModel {
 
    let type: Media = .movie
    var title: String?
    var longDesc: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["trackName"]
        longDesc <- map["longDescription"]
    }
}
