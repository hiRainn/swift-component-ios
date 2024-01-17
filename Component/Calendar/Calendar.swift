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
    @State private var createWeek: Bool = false
    @State private var pageNext: Bool = false

    @Namespace private var animation
    var body: some View {

        VStack(alignment: .center, spacing: 0,content: {
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
            .background(.white)
            Spacer()
            if currentDayHaveData() {
                dataView()
            } else {
                Text("no data")
            }
            Spacer()
        })
        .background(Color(red: 248/255, green: 248/255, blue: 255/255))


    }

    @ViewBuilder
    func CalendarHeader() -> some View {
        HStack(){
            //extenxion function in ViewExtension
            Text(currentDate.format("MMMM")).foregroundStyle(.blue)
            Text(currentDate.format("YYYY")).foregroundStyle(.gray)
            Spacer()
            Image(systemName: self.showFullCalendar ? "arrow.down.right.and.arrow.up.left" : "arrow.up.backward.and.arrow.down.forward" )
                .onTapGesture {
                    self.showFullCalendar.toggle()
                }
        }
        .padding(.leading,10)
        .padding(.top,10)
        .padding(.trailing,10)
        .background(.white)
    }

    @ViewBuilder
    func CompactCalendarView() -> some View {
        VStack{
            TabView(selection: self.$weekIndex){
                //fetch previos weekday
                ForEach(self.weekDays.indices,id: \.self) {index in
                    CompactCalendarTabView(self.weekDays[index])
                        .padding(.horizontal,8)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            //cause height of this tabview is too low,using PageTabViewStyle will result in overlapping styles,so we need to hidden the indicator
            //.tabViewStyle(PageTabViewStyle())
            .frame(height:100)
            .padding(.horizontal,-8)
        }
        .padding(.horizontal,8)
        .onChange(of: weekIndex, initial: false, {oldValue,newValue in
            //creating when it reaches first/last page
            if newValue == 0 || newValue == (weekDays.count - 1) {
                if (newValue - oldValue) > 0 {
                    pageNext = true
                } else {
                    pageNext = false
                }
                createWeek = true
            }
        })

    }

    func CelendarPageChange() {
        //week page change
        if weekDays.indices.contains(weekIndex) {
            if let firstDate =  weekDays[weekIndex].first?.date, weekIndex == 0 {
                weekDays.insert(firstDate.fetchPreviousWeek(), at: 0)
                weekDays.removeLast()
                weekIndex = 1
            }

            if let lastDate =  weekDays[weekIndex].last?.date, weekIndex == (weekDays.count - 1) {
                weekDays.append(lastDate.fetchNextWeek())
                weekDays.removeFirst()
                weekIndex = weekDays.count - 2

            }
        }
        //month page change

        //change current day
        if showFullCalendar {

        } else {
            if pageNext {
                currentDate = currentDate.getSomeDayAfter(7)!
            } else {
                currentDate = currentDate.getSomeDayAfter(-7)!
            }
        }
        print(currentDate)
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
                                    .vSpacing(.bottom)
                                    .offset(y:8)
                            }
                        }
                        )
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background{
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        //when the offset reaches 8 and the createWeek is true
                        if value.rounded() == 8 && createWeek {
                            CelendarPageChange()
                            createWeek = false
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
            weekDays.append(currentDate.fetchPreviousWeek())
            weekDays.append(currentWeek)
            weekDays.append(currentDate.fetchNextWeek())
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


