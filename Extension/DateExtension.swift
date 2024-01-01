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
            return date // 打印转化后的日期
        } else {
            print("日期格式不正确")
            return nil
        }
    }

    func format(_ format: String) -> String {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = format
        return dataFormatter.string(from: self)
    }
}

