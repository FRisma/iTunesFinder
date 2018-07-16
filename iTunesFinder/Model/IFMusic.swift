//
//  IFMusic.swift
//  iTunesFinder
//
//  Created by Franco Risma on 13/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import ObjectMapper

class IFMusic: IFBaseModel {
 
    let type: Media = .music
    var song: String?
    var artist: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        song <- map["trackName"]
        artist <- map["artistName"]
    }
}
