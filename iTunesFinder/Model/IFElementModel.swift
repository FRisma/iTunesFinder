//
//  IFBaseModel.swift
//  iTunesFinder
//
//  Created by Franco Risma on 16/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import ObjectMapper

public enum Media: Int {
    case tvShow  = 0
    case music   = 1
    case movie   = 2
    
    var description: String {
        switch self {
        case .music:
            return "music"
        case .movie:
            return "movie"
        case .tvShow:
            return "tvShow"
        }
        
    }
}

class IFElementModel: Mappable {
    var type: Media? { get { return nil } }
    var artWorkURL: String?
    var preview:    String?
    var longDesc:   String?
    var trackName:  String?
    var artistName: String?
    
    init(artistName: String?, trackName: String?, longDesc: String?, previewURL: String?, artWorkURL: String?) {
        self.artistName = artistName
        self.trackName = trackName
        self.longDesc = longDesc
        self.preview = previewURL
        self.artWorkURL = artWorkURL
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        artWorkURL  <- map["artworkUrl100"]
        preview     <- map["previewUrl"]
        trackName   <- map["trackName"]
        artistName 	<- map["artistName"]
        longDesc    <- map["longDescription"]
    }
    
}
