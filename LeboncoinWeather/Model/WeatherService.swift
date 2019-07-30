//
//  WeatherService.swift
//  WeatherLeboncoin
//
//  Created by hero on 30/07/2019.
//  Copyright © 2019 bessem. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherService {
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([WeatherModel]?) -> ()) {
        
        // endpoint
       // let weatherEndpoint = WeatherEndpoint.getForecastArray(latitude: "46.74004", logintude: "-1.60834")
        
        let weatherEndpoint = WeatherEndpoint.getForecastArray(latitude: "\(location.latitude)", longitude: "\(location.longitude)")
        let weatherUrlRequest = weatherEndpoint.request
        
        let task = URLSession.shared.dataTask(with: weatherUrlRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[WeatherModel] = []
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(nil)
                return
            }
            switch httpResponse.statusCode {
            case 200:
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        
                        for (key, value) in json {
                            let dateFormatterGet = DateFormatter()
                            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            if let time = dateFormatterGet.date(from: key) {
                                guard let dailyForcast = value as? [String : Any] else { return }
                                
                                let weatherModel = WeatherModel(time: time, json: dailyForcast)
                                forecastArray.append(weatherModel)
                                
                            }
                            
                        }
                         completion(forecastArray)
                    }
                } catch {
                     completion(nil)
                    print(error.localizedDescription)
                }
                
            default:
                print("Received HTTP response code: \(httpResponse.statusCode) - was not handled in NetworkProcessing.swift")
                completion(nil)
                
            }
            
        }
        
        task.resume()
    }
    
    
}
