//
//  WeatherEndoint.swift
//  WeatherLeboncoin
//
//  Created by hero on 30/07/2019.
//  Copyright © 2019 bessem. All rights reserved.
//

import Foundation

enum WeatherEndpoint {
    
    case getForecastArray(latitude: String, longitude: String)
    
    var request: URLRequest {
        var components = URLComponents(string: baseURL)!
        components.path = path
        components.queryItems = queryComponents
        
        let url = components.url!
        return URLRequest(url: url)
    }
    
    private var baseURL: String {
        return "http://www.infoclimat.fr/"
    }
    
    private var path: String {
        switch self {
        case .getForecastArray: return "/public-api/gfs/json"
        }
    }
    
    private struct ParameterKeys {
        static let location = "_ll"
        static let auth = "_auth"
        static let c = "_c"
    }
    
    private struct DefaultValues {
        static let auth = "BR9TRA5wUHICL1dgAXcAKVQ8U2ZaLAAnVCgGZVw3USwHY1MzUTJdP1A7WyYBLgojBzUOcAkwVW1UP1E1C2IDfwV5UzQObVAxAmVXNgE1ADVUeFMsWngAOVQoBn5cOVEyB3pTNVEzXTpQIVs4ATQKPQcqDm8JMFVoVChRKQtnA2UFYFMzDmlQMwJtVzQBMAAwVHhTLFpgAGxUNAY3XDFRMwdkUzVRN102UD9bagFiCj8HKg5sCTVVbVQwUTALYQNkBWBTKA5yUEsCHlcoAXEAdlQyU3VaeABtVGkGNQ=="
        static let c = "d464cbbbbd1de2796e7341e2265e8a0b"
    }
    
    private var parameters: [String : Any] {
        switch self {
        case .getForecastArray(let latitude, let longitude):
            let parameters: [String : Any] = [
                ParameterKeys.location : "\(latitude),\(longitude)",
                ParameterKeys.auth : DefaultValues.auth,
                ParameterKeys.c : DefaultValues.c
            ]
            
            return parameters
        }
    }
    
    private var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            print(queryItem)
            components.append(queryItem)
        }
        
        return components
    }

}
