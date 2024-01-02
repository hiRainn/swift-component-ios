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

    @Namespace private var animation
    var body: some View {
        VStack(alignment: .center, content: {
            //banner
            CalendarBanner()
            VStack(content: {
                if showFullCalendar {
                    FullCalendarView()
                } else {
                    TabView(selection: self.$weekIndex){
                        //fetch previos weekday
                        ForEach(self.weekDays.indices,id: \.self) {index in
                            CompactCalendarView(self.weekDays[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .hSpacer(.center)
                    .frame(height: 75)
                    .onChange(of: weekIndex, {
                        var addDay: Int
                        //page to previous week
                        if self.weekPreIndex - self.weekIndex > 0 {
                            addDay = -7
                            print("上个月")
                        } else {
                            addDay = 7
                            print("下个月")
                        }
                        withAnimation(.snappy) {
                            let calendar = Calendar.current
                            if let priviousWeekDay = calendar.date(byAdding: .day, value: addDay,to:  self.currentDate) {
                                self.currentDate = priviousWeekDay
                            }
                        }
                        //start
                        self.weekPreIndex = self.weekIndex
                        print(self.weekIndex)
                    })
                }
            })
            .onAppear{
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
    func CalendarBanner() -> some View {
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
    func FullCalendarView() -> some View{
        VStack(alignment: .leading,spacing: 6){
            Text("full")
        }
    }

    @ViewBuilder
    func CompactCalendarView(_ weekDay: [Date.WeekDay]) -> some View{
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
    func dataView() -> some View {
        VStack {
            Text("show your data")
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


