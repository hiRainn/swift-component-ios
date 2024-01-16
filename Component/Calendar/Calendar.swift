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
    @State private var moveWeek: Bool = true

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
            //extenxion function in ViewExtension
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
        .onChange(of: weekIndex, {oldValue,newValue in
            CompactCelendarChange(oldValue, newValue)
        })
    }

    func CompactCelendarChange(_ oldValue: Int,_ newValue: Int) {
        guard moveWeek else {
            moveWeek = true
            return
        }
        var addDay: Int
        //page to previous week
        if oldValue - newValue > 0 {
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
        //page to previous week
        if addDay < 0 {
            let week: [Date.WeekDay] = self.currentDate.fetchPreviousWeek()
            self.weekDays.removeLast()
            self.weekDays.insert(week, at: 0)
        } else {
            let week: [Date.WeekDay] = self.currentDate.fetchNextWeek()
            self.weekDays.removeFirst()
            self.weekDays.append(week)
        }
        DispatchQueue.main.async {
            moveWeek = false
            self.weekIndex = 1
        }
        print("=======")

    }
    @ViewBuilder
    func CompactCalendarTabView(_ weekDay: [Date.WeekDay]) -> some View{
        HStack(spacing:0){
            ForEach(weekDay) { day in
                VStack(spacing: 8){
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
                        .frame(width: 30,height: 30)
                        .background(content:{

                            if isSameDay(day.date, currentDate){
                                Circle()
                                    .fill(.blue)
                                    .matchedGeometryEffect(id:"TABINDICATOR", in: animation)
                            }

                            if day.data != nil {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 5,height: 5)
                                    .vSpacer(.bottom)
                                    .offset(y:8)
                            }
                        }
                        )
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacer(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
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
            let currentWeek = Date.fetchWeek()

            if let firstDate = currentWeek.first?.data {

            }

            if let lastDate = currentWeek.last?.data {
                
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


