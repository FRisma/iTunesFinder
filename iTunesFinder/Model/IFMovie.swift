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
 
    override var type: Media? { get { return .movie } }
    
    public func getTitle() -> String {
        return self.trackName ?? ""
    }
    
    public func getBrief() -> String {
        return self.longDesc ?? ""
    }
}
