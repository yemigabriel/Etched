//
//  Date+Extension.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/8/22.
//

import Foundation

extension Date {
    func formattedShortDate() -> String {
        var formattedDate = "Unknown"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    static func fileNameByTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddmmyyhhmmss"
        return dateFormatter.string(from: Date.now)
    }
}
