//
//  IFBaseModel.swift
//  iTunesFinder
//
//  Created by Franco Risma on 16/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import ObjectMapper

public enum Media: String {
    case music  = "music"
    case movie  = "movie"
    case tvShow = "tvShow"
}

class IFBaseModel: Mappable {
    var artWorkURL: String?
    var preview: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        artWorkURL <- map["artworkUrl100"]
        preview <- map["previewUrl"]
    }
    
}
