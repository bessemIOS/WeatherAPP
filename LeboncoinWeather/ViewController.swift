//
//  ViewController.swift
//  LeboncoinWeather
//
//  Created by hero on 30/07/2019.
//  Copyright © 2019 bessem. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    let locationService = LocationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Location service callbacks
        locationService.newestLocation = { [weak self] coordinate in
            guard let self = self, let coordinate = coordinate else { return }
            print("Location is: \(coordinate)")
            self.getForecast(for: coordinate)
        }
        locationService.statusUpdated = { [weak self] status in
            if status == .authorizedWhenInUse {
                self?.locationService.getLocation()
            }
        }
        
        switch locationService.status {
        case .notDetermined:
            locationService.getPermission()
        case .authorizedWhenInUse:
            locationService.getLocation()
        default: assertionFailure("Location is: \(locationService.status)")
        }
    }
    
    func getForecast(for coordinates: CLLocationCoordinate2D) {
        WeatherService.forecast(withLocation: coordinates) { forecastArray in
            if let forecastArray  = forecastArray {
                print(forecastArray[0])
                
            }
        }
        
    }


}

