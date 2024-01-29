//
//  TimeLineData.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/5.
//

import SwiftUI

func initTimeLineData() -> [SomeData] {
    let startTime: Date = .init()
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: startTime)
    let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        .addingTimeInterval(-1)
        //only need today's data
    return getDataByDate(startOfDay,endOfDay)
}

