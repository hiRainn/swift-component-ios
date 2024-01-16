//
//  DateExtension.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/2.
//

import Foundation

extension Date {
    static func setDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            print("date format error")
            return nil
        }
    }

    static func setTime(_ timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: timeString) {
            return date
        } else {
            print("time format error")
            return nil
        }
    }

    func format(_ format: String) -> String {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = format
        return dataFormatter.string(from: self)
    }
}

