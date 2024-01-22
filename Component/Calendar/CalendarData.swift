//
//  CalendarData.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/2.
//

import SwiftUI

struct SomeData: Identifiable {
    var id: UUID = .init()
    var title: String
    var content: String
    var createAt: Date
}

//if you need to put some datas into your celendar
var today: Date = .init()

var DataList: [SomeData] = []

//mock database data
func initDataList() {
    //mock 3 * 30 days' data
    for i in 0...30 {
        //random num data
        for  randomInt in 0...Int.random(in: 1...20) {
            let data: SomeData = SomeData(title: "title" + String(randomInt), content: "concent" + today.getSomeDayAfter(i * 3)!.format("yyyy-MM-dd"), createAt: today.getSomeDayAfter(i * 3)!)
            DataList.append(data)
        }
        for  randomInt in 0...Int.random(in: 1...20) {
            let data: SomeData = SomeData(title: "title" + String(randomInt), content: "concent" + today.getSomeDayAfter(-i * 3)!.format("yyyy-MM-dd"), createAt: today.getSomeDayAfter(-i * 3)!)
            DataList.append(data)
        }
    }

}

//mock query data
func getDataByDate(_ startDay: Date,_ endDay: Date) -> [SomeData] {
    var data: [SomeData] = []
    DataList.forEach { d in
        if d.createAt >= startDay && d.createAt <= endDay {
            data.append(d)
        }
    }

    return data
}


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
        guard let endOfWeek = weekForDate?.end else {
            return []
        }
        //mock get date
        var data: [SomeData] = []
        data = getDataByDate(startOfWeek, endOfWeek)

        for index in 0..<7 {
            if let weekDay = calendar.date(byAdding: .day,value: index ,to: startOfWeek) {
                var w: CalendarDay =  CalendarDay(date:weekDay)
                var d: [SomeData] = []
                //get data
                data.forEach{ value in
                    if weekDay.isSameDay(value.createAt) {
                        d.append(value)
                    }
                }
                if d.count != 0 {
                    w.data = d
                }
                week.append(w)
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

    static func fetchMonth(_ date: Date = .init()) -> [[CalendarDay]] {
        var month: [[CalendarDay]] = []
        var week: [CalendarDay] = []
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let startDate = calendar.startOfDay(for: date)
        let monthForDate = calendar.dateInterval(of: .month, for: startDate)

        guard let startOfMonth = monthForDate?.start else {
            return []
        }

        //find first sunday of this month
        let weekdayOfFirstDay = calendar.component(.weekday, from: startOfMonth)
        let firstSunday = calendar.date(byAdding: .day, value: 1-weekdayOfFirstDay, to: startOfMonth)!

        //mock get date
        var data: [SomeData] = []
        //One page has a total of 42 days
        data = getDataByDate(firstSunday, firstSunday.getSomeDayAfter(41)!)

        for x in 0..<6 {
            for y in 0..<7 {
                let addValue: Int = x * 7 + y
                if let weekDay = calendar.date(byAdding: .day,value: addValue ,to: firstSunday) {
                    var w: CalendarDay =  CalendarDay(date:weekDay)
                    var d: [SomeData] = []
                    //get data
                    data.forEach{ value in
                        if weekDay.isSameDay(value.createAt) {
                            d.append(value)
                        }
                    }
                    if d.count != 0 {
                        w.data = d
                    }
                    week.append(w)
                }
            }
            month.append(week)
            week.removeAll()
        }
        return month
    }

    func fetchPreviousMonth() -> [[CalendarDay]] {
        let calendar = Calendar.current
        guard let priviousMonthkDay = calendar.date(byAdding: .month, value: -1, to: self) else {
            return []
        }

        return Date.fetchMonth(priviousMonthkDay)
    }

    func fetchNextMonth() -> [[CalendarDay]] {
        let calendar = Calendar.current
        guard let nextMonthDay = calendar.date(byAdding: .month, value: 1, to: self) else {
            return []
        }

        return Date.fetchMonth(nextMonthDay)
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


