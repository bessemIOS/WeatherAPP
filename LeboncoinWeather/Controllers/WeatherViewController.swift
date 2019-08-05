//
//  WeatherViewController.swift
//  LeboncoinWeather
//
//  Created by hero on 30/07/2019.
//  Copyright © 2019 bessem. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    // MARK: - Properties
    let locationService = LocationService()
    
    // MARK: - Injection
    let weatherViewModel = WeathersViewModel(weatherService: WeatherService())
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorStart()
        
        self.forecastTableView.dataSource = self
        self.forecastTableView.delegate = self
        self.forecastTableView.tableFooterView = UIView()
        
        // Location service callbacks
        weatherViewModel.didFinishFetch = {
            DispatchQueue.main.async {
                self.activityIndicatorStop()
                self.forecastTableView.reloadData()
            }
        }
        
        locationService.newestLocation = { coordinate in
            guard let coordinate = coordinate else { return }
            print("Location is: \(coordinate)")
            self.weatherViewModel.fetchForecast(for: coordinate)
            
            
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWeatherDetailIdentifier {
            let weatherDetailTVC = segue.destination as! WeatherDetailViewController
            weatherDetailTVC.weatherVM = sender as? WeathersViewModel
        }
    }
    
    private func activityIndicatorStart() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func activityIndicatorStop() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
}

//MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherViewModel.weatherArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.weatherArray?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        guard let weatherVM = weatherViewModel.setupProperties(of: indexPath) else {return cell}
        cell.textLabel?.text = weatherVM.hour
        cell.detailTextLabel?.text = weatherVM.temperature
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return weatherViewModel.getHeaderText(of: section)
    }
}

// MARK: - UITableViewDelagate

let showWeatherDetailIdentifier = "showWeatherDetail"

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weatherVM = weatherViewModel.setupProperties(of: indexPath) else {return }
        performSegue(withIdentifier: showWeatherDetailIdentifier, sender: weatherVM)
    }
}
