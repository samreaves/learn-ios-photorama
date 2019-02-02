//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Sam Reaves on 2/2/19.
//  Copyright © 2019 Sam Reaves Digital. All rights reserved.
//

import Foundation

struct FlickrAPI {
    enum Method: String {
        case interestingPhotos = "flickr.interestingness.getList"
    }
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "08b4104b06917923c90be54ef77969fa"
    
    private static func flickrURL(method: Method,
                                  parameters: [String: String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static var interestingPhotosURL: URL = {
        return flickrURL(method: .interestingPhotos,
                         parameters: ["extras": "url_h,date_taken"])
    }()
}
