//
//  WeatherDetailViewController.swift
//  LeboncoinWeather
//
//  Created by hero on 04/08/2019.
//  Copyright © 2019 bessem. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UITableViewController {
    
    var weatherVM: WeathersViewModel?
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var pluie: UILabel!
    @IBOutlet weak var pression: UILabel!
    @IBOutlet weak var humidite: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.day.text = weatherVM?.day
        self.date.text = weatherVM?.date
        self.temperature.text = weatherVM?.temperature
        self.pluie.text = weatherVM?.pluie
        self.pression.text = weatherVM?.pression
        self.humidite.text = weatherVM?.humidite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return UITableView.automaticDimension
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }    
    

}
