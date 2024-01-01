//
//  CalendarData.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/2.
//

import SwiftUI

struct SomeData: Identifiable {
    var id: UUID = .init()
}

//if you need to put some datas into your celendar
var DataList: [SomeData] = []

//extension functions of Date
extension Date {

    //fetch current weekdays
    static func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        var week: [WeekDay] = []
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startDate)

        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        for index in 0..<7 {
            if let weekDay = calendar.date(byAdding: .day,value: index ,to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        return week
    }

    //fetch previous weekdays
    func fetchPreviousWeek() -> [WeekDay] {
        var week: [WeekDay] = []
        let calendar = Calendar.current
        if let priviousWeekDay = calendar.date(byAdding: .day, value: -7, to: self) {
            let startPriviousWeek = calendar.startOfDay(for: priviousWeekDay)
            let previousWeekForDate = calendar.dateInterval(of: .weekOfMonth, for: startPriviousWeek)
            guard let startOfWeek = previousWeekForDate?.start else {
                return []
            }
            for index in 0..<7 {
                if let weekDay = calendar.date(byAdding: .day,value: index ,to: startOfWeek) {
                    week.append(.init(date: weekDay))
                }
            }
        }
        return week
    }

    //fetch next weekdays
    func fetchNextWeek() -> [WeekDay] {
        var week: [WeekDay] = []
        let calendar = Calendar.current
        if let nextWeekDay = calendar.date(byAdding: .day, value: 7, to: self) {
            let nextPriviousWeek = calendar.startOfDay(for: nextWeekDay)
            let NextWeekForDate = calendar.dateInterval(of: .weekOfMonth, for: nextPriviousWeek)
            guard let startOfWeek = NextWeekForDate?.start else {
                return []
            }
            for index in 0..<7 {
                if let weekDay = calendar.date(byAdding: .day,value: index ,to: startOfWeek) {
                    week.append(.init(date: weekDay))
                }
            }
        }
        return week
    }

    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
        var data: Any?

        init(date day: Date) {
            self.date = day
        }

        init(date day: Date,date data: Any?) {
            self.date = day
            self.data = data
        }
    }
}


