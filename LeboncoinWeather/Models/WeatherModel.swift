//
//  WeatherModel.swift
//  WeatherLeboncoin
//
//  Created by hero on 30/07/2019.
//  Copyright © 2019 bessem. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let date: Date?
    let hour: Int?
    let temperature: Int?
    let pression: Int?
    let pluie: Double?
    let humidite: Double?
    let risqueNeige: String?
    
    init(date: Date?, hour: Int?, json: [String : Any]?) {
        self.date = date
        self.hour = hour
        if let temperature = json?["temperature"] as? [String : Any] {
            if let kelvinTemp = temperature["2m"]  as? Double {
                let celsiusTemp = Int(kelvinTemp - 273.15)
                self.temperature = celsiusTemp
            } else {
                self.temperature = nil
            }
        } else {
            self.temperature = nil
        }
        
        if let pression = json?["pression"] as? [String : Any] {
            self.pression = pression["niveau_de_la_mer"] as? Int
        } else {
            self.pression = nil
        }
        
        if let pluie = json?["pluie"] as? Double {
            self.pluie = pluie
        } else {
            self.pluie = nil
        }
        
        if let humidite = json?["humidite"] as? [String : Any] {
            self.humidite = humidite["2m"] as? Double
        } else {
            self.humidite = nil
        }
        
        if let risqueNeige = json?["risque_neige"] as? String {
            self.risqueNeige = risqueNeige
        } else {
            self.risqueNeige = nil
        }
    }
    
    
    
}

