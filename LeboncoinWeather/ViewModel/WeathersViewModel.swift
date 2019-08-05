//
//  WeathersViewModel.swift
//  LeboncoinWeather
//
//  Created by hero on 03/08/2019.
//  Copyright © 2019 bessem. All rights reserved.
//

import Foundation
import CoreLocation

class WeathersViewModel {
    
    //  MARK: - Properties
    
    var date: String?
    var day: String?
    var hour: String?
    var temperature: String?
    var pression: String?
    var pluie: String?
    var humidite: String?
    var risqueNeige: String?
    
    var weatherArray: [[WeatherModel]]? {
        didSet {
            guard let _ = weatherArray else { return }
            
            self.didFinishFetch?()
        }
    }
        
    private var weatherService: WeatherService?
    
    // MARK: - Closures for callback
        var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    // MARK: - Network call
    func fetchForecast (for coordinates:CLLocationCoordinate2D?) {
        weatherService?.fetchForecast(withLocation: coordinates) { forecastArray in
            if let forecastArray  = forecastArray {
                
                let groupedMessages = Dictionary(grouping: forecastArray) { (element) -> Date in
                    return element.date!
                }
                let sortedKeys = groupedMessages.keys.sorted()
                var forecastArray = [[WeatherModel]]()
                sortedKeys.forEach { (key) in
                    let values = groupedMessages[key]
                    let sortedValues = values?.sorted(by: { $0.hour! < $1.hour! })
                    
                    forecastArray.append(sortedValues!)
                    
                }
                self.weatherArray = forecastArray
                
            }
            self.didFinishFetch?()
            
        }
        
    }
    
    // MARK: - UI Logic
    func getHeaderText (of section: Int) -> String? {
        guard let date = weatherArray?[section].first?.date else { return nil }
        let minMax = getMinMaxTemp(of: section)
        let dateWithoutTime = date.stripTime()
        guard let day = getDay(from: date) else { return nil }
        return "\(day) \(dateWithoutTime)  \(minMax)"
    }
    
    func getMinMaxTemp (of section: Int) -> String {
        let x = weatherArray?[section].sorted{ $0.temperature! < $1.temperature!}
        guard let min = x?.first?.temperature, let max = x?.last?.temperature else {return ""}
        return "\(min)° - \(max)°"
    }
    
    func setupProperties(of indexPath: IndexPath) -> WeathersViewModel? {
        
        guard let weatherModel =  weatherArray?[indexPath.section][indexPath.row] else { return nil }
        self.hour = "\(weatherModel.hour!) h"
        self.date = weatherModel.date?.stripTime()
        self.day = getDay(from: weatherModel.date!)
        self.temperature = "\(weatherModel.temperature!)°"
        self.pression = "\(weatherModel.pression!)"
        self.pluie = "\(weatherModel.pluie!)"
        self.humidite = "\(weatherModel.humidite!)"
        self.risqueNeige = "\(weatherModel.risqueNeige!)"
        
        return self
        
    }
    
    func getDay (from date:Date) -> String? {
        if date.isToday() {
            return "Today"
        } else if let day = date.dayOfWeek() {
            return "\(day)"
        } else {
            return nil
        }
    }
    
}
