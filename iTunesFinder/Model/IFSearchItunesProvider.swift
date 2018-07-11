//
//  IFSearchItunesProvider.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit
import Alamofire

class IFSearchItunesProvider: NSObject {

    // https://itunes.apple.com/search?term=jack+johnson&media=music
    let music = "music"
    let tvShow = "tvShow"
    let movie = "movie"
    let term : String? = nil
    let baseURL = "https://itunes.apple.com/search"
    
    
    public func fetchData(onSuccess: @escaping ([String]?) -> Void, onFailure: @escaping (Error?) -> Void) {
        Alamofire.request(baseURL,
                          method: .get,
                          parameters: ["term": "Muse",
                                       "media": music])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching: \(String(describing: response.result.error))")
                    onFailure(response.result.error)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["rows"] as? [[String: Any]] else {
                        print("Malformed data received from provider")
                        onFailure(nil)
                        return
                }
                
                //let rooms = rows.flatMap { roomDict in return RemoteRoom(jsonData: roomDict) }
                //completion(rooms)
                onSuccess(["HOla"])
        }
    }
}
