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
    static func fetchWeek(_ date: Date = .init()) -> [CalendarDay] {
        var week: [CalendarDay] = []
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
    func fetchPreviousWeek() -> [CalendarDay] {
        let calendar = Calendar.current
        guard let priviousWeekDay = calendar.date(byAdding: .day, value: -7, to: self) else {
            return []
        }
        return Date.fetchWeek(priviousWeekDay)
    }

    //fetch next weekdays
    func fetchNextWeek() -> [CalendarDay] {
        let calendar = Calendar.current
        guard let nextWeekDay = calendar.date(byAdding: .day, value: 7, to: self) else {
            return []
        }
        return Date.fetchWeek(nextWeekDay)
    }

    static func fetchMonth(_ date: Date = .init()) -> [[[CalendarDay]]] {
        var month: [[[CalendarDay]]] = []
        var week: [CalendarDay] = []
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let monthForDate = calendar.dateInterval(of: .month, for: startDate)

        guard let startOfMonth = monthForDate?.start else {
            return []
        }
        for x in 0 ..< 6 {
            for y in 0..<7 {
                var addValue: Int = x * 7 + y
                if let weekDay = calendar.date(byAdding: .day,value: addValue ,to: startOfMonth) {
                    week.append(.init(date: weekDay))
                }
            }
            month.append([week])
        }

        return month
    }

    func fetchPreviousMohtn() -> [[[CalendarDay]]] {
        let calendar = Calendar.current
        guard let priviousWeekDay = calendar.date(byAdding: .month, value: -1, to: self) else {
            return []
        }

        return Date.fetchMonth()
    }

    func fetchNextMohtn() -> [[[CalendarDay]]] {
        let calendar = Calendar.current
        guard let priviousWeekDay = calendar.date(byAdding: .month, value: 1, to: self) else {
            return []
        }

        return Date.fetchMonth()
    }

    struct CalendarDay: Identifiable {
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


