//
//  Calendar.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/2.
//

import SwiftUI
struct CalendarView: View {
    @State private var showFullCalendar = false
    @State private var currentDate: Date = .init()
    @State private var weekDays: [[Date.WeekDay]] = []
    @State private var weekIndex: Int = 1
    @State private var weekPreIndex: Int = 1
    @State private var moveCalendar: Bool = false

    @Namespace private var animation
    var body: some View {
        VStack(alignment: .center, content: {
            //header
            CalendarHeader()
            VStack(content: {
                if showFullCalendar {
                    FullCalendarView()
                } else {
                    CompactCalendarView()

                }
            })
            .onAppear{
                onAppearEvent()
            }
        })
        Spacer()
        if currentDayHaveData() {
            dataView()
        } else {
            Text("no data")
        }
        Spacer()

    }

    @ViewBuilder
    func CalendarHeader() -> some View {
        HStack(spacing: 5){
            //extenxion 实现的Date函数format
            Text(currentDate.format("MMMM")).foregroundStyle(.blue)
            Text(currentDate.format("YYYY")).foregroundStyle(.gray)
            Spacer()
            Image(systemName: self.showFullCalendar ? "arrow.down.right.and.arrow.up.left" : "arrow.up.backward.and.arrow.down.forward" )
                .onTapGesture {
                    self.showFullCalendar.toggle()
                }
        }
        .padding()
    }

    @ViewBuilder
    func CompactCalendarView() -> some View {
        TabView(selection: self.$weekIndex){
            //fetch previos weekday
            ForEach(self.weekDays.indices,id: \.self) {index in
                CompactCalendarTabView(self.weekDays[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        //cause height of this tabview is too low,using PageTabViewStyle will result in overlapping styles,so we need to hidden the indicator
        //.tabViewStyle(PageTabViewStyle())
        .hSpacer(.center)
        .frame(height: 75)
        .onChange(of: weekIndex, {
            if !self.moveCalendar {
                print(self.currentDate)
                self.moveCalendar.toggle()
                var addDay: Int
                //page to previous week
                if self.weekPreIndex - self.weekIndex > 0 {
                    addDay = -7
                } else {
                    addDay = 7
                }
                withAnimation(.snappy) {
                    let calendar = Calendar.current
                    if let priviousWeekDay = calendar.date(byAdding: .day, value: addDay,to:  self.currentDate) {
                        self.currentDate = priviousWeekDay
                    }

                }
                //save previous index of tab
                self.weekPreIndex = self.weekIndex
                //page to previous week
                if addDay < 0 {
                    var week: [Date.WeekDay] = self.currentDate.fetchPreviousWeek()
                    self.weekDays.removeLast()
                    self.weekDays.insert(week, at: 0)

                } else {
                    var week: [Date.WeekDay] = self.currentDate.fetchNextWeek()
                    self.weekDays.removeFirst()
                    self.weekDays.append(week)
                }
                print(self.weekDays[0][0].date)
                print(self.weekDays[1][0].date)
                print(self.weekDays[2][0].date)
                print(self.currentDate)
                self.weekIndex = 1
                print(self.weekIndex)
                self.moveCalendar.toggle()
            }

        })
    }

    @ViewBuilder
    func CompactCalendarTabView(_ weekDay: [Date.WeekDay]) -> some View{
        HStack(spacing:5){
            ForEach(weekDay) { day in
                VStack(spacing: 2){
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    Text(day.date.format("dd"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDay(day.date, self.currentDate) ? .white : .gray)
                        .frame(width: 36,height: 36)
                        .background(content:{

                            if isSameDay(day.date, currentDate){
                                Circle()
                                    .fill(.blue)
                                    .matchedGeometryEffect(id:"TABINDICATOR", in: animation)
                            }

                            if day.data != nil {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 6,height: 6)
                                    .offset(y:23)
                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacer(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.interactiveSpring) {
                        currentDate = day.date
                    }
                }
            }
        }
        
    }

    @ViewBuilder
    func FullCalendarView() -> some View{
        VStack(alignment: .leading,spacing: 6){
            Text("full")
        }
    }

    @ViewBuilder
    func dataView() -> some View {
        VStack {
            Text("show your data")
        }

    }

    func onAppearEvent() {
        if self.weekDays.isEmpty {
            let preWeek = self.currentDate.fetchPreviousWeek()
            if !preWeek.isEmpty {
                self.weekDays.append(preWeek)
            }
            let currentWeek = Date.fetchWeek()
            self.weekDays.append(currentWeek)
            let nextWeek = self.currentDate.fetchNextWeek()
            if !nextWeek.isEmpty {
                self.weekDays.append(nextWeek)
            }
        }

        //create same data in weekday
        for i in 0..<self.weekDays.count {
            let calendar = Calendar.current
            for (index,value) in self.weekDays[i].enumerated() {
                //add today datas
                if isSameDay(value.date, self.currentDate) {
                    self.weekDays[i][index].data = "1"
                }

                //add 2 day's after datas
                if let day2after = calendar.date(byAdding: .day, value: 2, to: self.currentDate) {
                    if isSameDay(value.date, day2after) {
                        self.weekDays[i][index].data = "2"
                    }
                }
                //add 2 day's ago datas
                if let day2ago = calendar.date(byAdding: .day, value: -2, to: self.currentDate) {
                    if isSameDay(value.date, day2ago) {
                        self.weekDays[i][index].data = "2"
                    }
                }
                //add 1 week's after datas
                if let dayWeekAfter = calendar.date(byAdding: .day, value: 10, to: self.currentDate) {
                    if isSameDay(value.date, dayWeekAfter) {
                        self.weekDays[i][index].data = "2"
                    }
                }

            }
        }
    }

    func isSameDay(_ day1: Date, _ day2: Date) -> Bool {
        return Calendar.current.isDate(day1, inSameDayAs: day2)
    }

    func currentDayHaveData() -> Bool {
        var has: Bool = false
        for i in 0..<self.weekDays.count {
            for v in self.weekDays[i] {
                if isSameDay(self.currentDate, v.date) && v.data != nil {
                    has.toggle()
                }
            }
        }
        return has
    }
}

#Preview {
    CalendarView()
}


