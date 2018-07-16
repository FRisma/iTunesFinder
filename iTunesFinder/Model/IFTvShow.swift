//
//  IFTvShow.swift
//  iTunesFinder
//
//  Created by Franco Risma on 13/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import ObjectMapper

class IFTvShow: IFBaseModel {
    
    let type: Media = .tvShow
    var title :String?
    var episode :String?
    var longDesc : String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["artistName"]
        episode <- map["trackName"]
        longDesc <- map["longDescription"]
    }
}
