
//
//  IFSearchItunesProvider.swift
//  iTunesFinder
//
//  Created by Franco Risma on 11/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//


//                        if let results = jsonArray!["results"] as! NSArray? {
//                            for item in results as! NSDictionary {
//                                //                                let imageURL = item["artWorkUrl60"] as? String
//                                //                                let artistName = item["artWorkUrl60"] as? String
//                                //                                let trackName = item["trackName"] as? String
//                                //self.nameArray.append((name)!)
//                                //self.imageURLArray.append((imageURL)!)
//                                print(item)
//                            }
//                        }
//                    }
// Old code
//                    guard response.result.isSuccess else {
//                        print("Error while fetching: \(String(describing: response.result.error))")
//                        onFailure(response.result.error)
//                        return
//                    }
//
//                    guard let value = response.result.value as? [String: Any],
//                        let rows = value["rows"] as? [[String: Any]] else {
//                            print("Malformed data received from provider")
//                            //let error = Error(domain:"", code:123, userInfo:nil)
//                            onFailure(nil)
//                            return
//                    }
//
//                    //let rooms = rows.flatMap { roomDict in return RemoteRoom(jsonData: roomDict) }
//                    onSuccess(IFSearchResponse())

import UIKit
import Alamofire

class IFSearchItunesProvider {
    
    static let singleton = IFSearchItunesProvider()
    
    private init() {
    }
    
    func fetchMusic(for artist: String, onSuccess:@escaping ([IFMusic]) -> Void, onFailure:@escaping (Error) -> Void ) {
        Alamofire.request(API_URL,
                          method: .get,
                          parameters: ["term": artist, "media": Media.music.rawValue])
            .responseString() { response in
                
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
    
//    func fetchMovies(for artist: String, onSuccess:([IFMusic]), onFailure:(Error) ) {
//        self.fetchData(fromApi: API_URL,
//                       method: .get,
//                       parameters: ["term": artist, "media": Media.movie.rawValue],
//                       onCompletion:{ (result,error) in
//                        print("jamon")
//        })
//    }
//
//    func fetchTvShows(for artist: String, onSuccess: ([IFMusic]), onFailure:(Error) ) {
//        self.fetchData(fromApi: API_URL,
//                       method: .get,
//                       parameters: ["term": artist, "media": Media.tvShow.rawValue],
//                       onCompletion:{ result,error in
//                        print("jamon")
//        })
//    }
    
//    func fetchData(fromApi baseURL: String, method: HTTPMethod, parameters: Dictionary<String,String>, onCompletion completion: @escaping ([Any]?, Error?) -> Void) {
//        Alamofire.request(baseURL,
//                          method: method,
//                          parameters: parameters)
//            .responseString() { response in
//
//                switch(response.result) {
//                case .success (let responseString):
//                    if let dataResponse = IFSearchResponse(JSONString: "\(responseString)") {
//                        if let objects = dataResponse.result {
//                            if objects.isEmpty {
//                                completion([],nil)
//                            } else {
//                                completion(dataResponse.result!, nil)
//                            }
//                        } else {
//                            completion([],nil)
//                        }
//                    }
//                case .failure(let error):
//                    print(error)
//                    completion([],error)
//                }
//        }
//    }
}
