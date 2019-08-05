//
//  Extention+Date.swift
//  LeboncoinWeather
//
//  Created by hero on 03/08/2019.
//  Copyright © 2019 bessem. All rights reserved.
//

import Foundation

extension Date {
    static func dateFromCustomString(customString: String) -> Date? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterGet.date(from: customString)
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: "\(year)-\(month)-\(day)")!
    }
    func stripTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func isToday() -> Bool {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return true }
        else { return false }
    }
    
    func getHour() -> Int? {
        let calendar = Calendar.current
         return calendar.component(.hour, from: self)
    }
    
}
