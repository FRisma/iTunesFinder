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
    
    override var type: Media? { get { return .music } }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public func getArtist() -> String {
        return self.artistName ?? ""
    }
    
    public func getSong() -> String {
        return self.trackName ?? ""
    }
}
