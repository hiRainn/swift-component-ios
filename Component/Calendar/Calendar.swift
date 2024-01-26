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
    @State private var showData: [SomeData] = []
    @State private var weekDays: [[Date.CalendarDay]] = []
    @State private var monthDays: [[[Date.CalendarDay]]] = []
    @State private var pageIndex: Int = 1
    @State private var createPage: Bool = false
    @State private var scollTop: Bool = false

    @Namespace private var animation
    @Namespace private var fullAnimation
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
            if self.showData.count != 0 {
                ScrollViewReader { scrollViewProxy in
                    ScrollView{
                        dataView().hSpacing(.center)
                    }
//                    .frame(maxHeight: 400)
                    .background(.yellow,in: .rect(cornerRadius: 20))
                    .padding(12)
                    .onChange(of: currentDate ,{
                        withAnimation{
                            scrollViewProxy.scrollTo(0)
                        }
                    })
                }
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
            TabView(selection: self.$pageIndex){
                //fetch previos weekday
                ForEach(self.weekDays.indices,id: \.self) {index in
                    CompactCalendarTabView(self.weekDays[index])
                        .padding(.horizontal,8)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height:100)
            .padding(.horizontal,-8)
            .onChange(of: pageIndex, initial: false, {oldValue,newValue in
                //creating when it reaches first/last page
                if newValue == 0 || newValue == 2 {
                    createPage = true
                }
            })
        }
        .padding(.horizontal,8)
    }

    @ViewBuilder
    func CompactCalendarTabView(_ weekDay: [Date.CalendarDay]) -> some View{
        HStack(spacing:0){
            ForEach(weekDay) { day in
                VStack(spacing: 8){
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    Text(day.date.format("d"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(day.date.isSameDay(self.currentDate) ? .white : .gray)
                        .frame(width: 30,height: 30)
                        .background(content:{
                            if day.date.isSameDay(currentDate){
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
//                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                        setShowData(day)
                    }
                    //rebuild month data
                    monthDays.removeAll()
                    monthDays.append(currentDate.fetchPreviousMonth())
                    monthDays.append(Date.fetchMonth(currentDate))
                    monthDays.append(currentDate.fetchNextMonth())
                }
                .onAppear{
                    setShowData(day)
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
                        if value.rounded() == 8 && createPage {
                            CelendarPageChange(true)
                            createPage = false
                        }
                    }
            }
        }

    }

    @ViewBuilder
    func FullCalendarView() -> some View{
        VStack{
            TabView(selection: self.$pageIndex){
                //fetch previos weekday
                ForEach(self.monthDays.indices,id: \.self) {index in
                    FullCalendarTabView(self.monthDays[index], index)
                        .padding(.horizontal,8)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height:288)
            .padding(.horizontal,-8)
            .onChange(of: pageIndex, initial: false, {oldValue,newValue in
                //creating when it reaches first/last page
                if newValue == 0 || newValue == 2 {
                    createPage = true
                }
            })
        }
        .padding(.horizontal,8)
    }

    @ViewBuilder
    func FullCalendarTabView(_ monthDay: [[Date.CalendarDay]],_ selectIndex: Int) ->some View {
        VStack{
            ForEach(0..<monthDay.count, id: \.self) { index in
                HStack(spacing:0){
                    ForEach(monthDay[index]) { day in
                        VStack(spacing: 8){
                            if index == 0 {
                                Text(day.date.format("E"))
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .textScale(.secondary)
                                    .foregroundStyle(.gray)
                            }
                            Text(day.date.format("d"))
                                .font(.title2)
                                .fontWeight(.bold)
                                .textScale(.secondary)
                                .foregroundStyle(getCalendarTextColor(day.date,selectIndex))
                                .frame(width: 30,height: 30)
                                .background(content:{
                                    if day.date.isSameDay(currentDate) && selectIndex == 1{
                                        Circle()
                                            .fill(.blue)
                                            .matchedGeometryEffect(id:"FULLTABINDICATOR", in: fullAnimation)
                                    }

                                    if day.data != nil {
                                        Circle()
                                            .fill(.red)
                                            .frame(width: 5,height: 5)
                                            .vSpacing(.bottom)
                                            .offset(y:8)
                                    }
                                })
                        }
                        .hSpacing(.center)
                        .contentShape(.rect)
                        .onTapGesture {
                            //if tap date is not this month,page to that month
                            let currentMonth: Int = isSameMonth(day.date, currentDate)
                            //currentMonth eq 0 means the same month
                            if currentMonth == 0 {
                                withAnimation(.snappy) {
                                    currentDate = day.date
                                    setShowData(day)
                                }
                                //rebuild week data
                                weekDays.removeAll()
                                weekDays.append(currentDate.fetchPreviousWeek())
                                weekDays.append(Date.fetchWeek(currentDate))
                                weekDays.append(currentDate.fetchNextWeek())
                            } else {
                                currentDate = day.date
                                withAnimation(.snappy) {
                                    self.pageIndex = currentMonth + 1
                                    CelendarPageChange(false)
                                }
                            }
                        }
                        .onAppear{
                            setShowData(day)
                        }
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
                    if value.rounded() == 8 && createPage {
                        CelendarPageChange(true)
                        createPage = false
                    }
                }
            }
        }
    }

    func getCalendarTextColor(_ day: Date,_ index: Int) -> Color {
        let calendar = Calendar.current
        let monthAter: Int = index - 1
        let compareDay: Date = calendar.date(byAdding: .month, value: monthAter, to: currentDate)!

        var color: Color = .gray
        if day.isSameDay(compareDay) {
            if index == 1 {
                color = .white
            } else {
                color = .gray
            }
        } else {
            let compareRes = isSameMonth(day,compareDay)
            if compareRes != 0 {
                color = Color(red: 224/255, green: 224/255, blue: 224/255)
            }
        }
        return color
    }

    func CelendarPageChange(_ changeCurrentDay: Bool) {
        let calendar = Calendar.current
        if showFullCalendar {
            //month page change
            if monthDays.indices.contains(pageIndex) {
                if pageIndex == 0 {
                    let newDate: Date = calendar.date(byAdding: .month, value: -1, to: currentDate)!
                    if changeCurrentDay {
                        monthDays.insert(newDate.fetchPreviousMonth(), at: 0)
                        currentDate = newDate
                    } else {
                        monthDays.insert(currentDate.fetchPreviousMonth(), at: 0)
                    }
                    monthDays.removeLast()
                    pageIndex = 1
                }
                if pageIndex == 2 {
                    let newDate: Date = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                    if changeCurrentDay {
                        monthDays.append(newDate.fetchNextMonth())
                        currentDate = newDate
                    } else {
                        monthDays.append(currentDate.fetchNextMonth())
                    }
                    monthDays.removeFirst()
                    pageIndex = 1
                }
            }
            weekDays.removeAll()
            weekDays.append(currentDate.fetchPreviousWeek())
            weekDays.append(Date.fetchWeek(currentDate))
            weekDays.append(currentDate.fetchNextWeek())
        } else {
            //week page change
            if weekDays.indices.contains(pageIndex) {
                if pageIndex == 0 {
                    currentDate = currentDate.getSomeDayAfter(-7)!
                    weekDays.insert(currentDate.fetchPreviousWeek(), at: 0)
                    weekDays.removeLast()
                    pageIndex = 1
                }

                if pageIndex == 2 {
                    currentDate = currentDate.getSomeDayAfter(7)!
                    weekDays.append(currentDate.fetchNextWeek())
                    weekDays.removeFirst()
                    pageIndex = 1
                }
            }
            monthDays.removeAll()
            monthDays.append(currentDate.fetchPreviousMonth())
            monthDays.append(Date.fetchMonth(currentDate))
            monthDays.append(currentDate.fetchNextMonth())
        }
    }

    @ViewBuilder
    func dataView() -> some View {
        VStack(alignment:.leading){
            ForEach(self.showData.indices, id:\.self) { index in
                Text(self.showData[index].title).padding(.top,10).id(index)
                Text(self.showData[index].content)
                Text(self.showData[index].createAt.format("yyyy-MM-dd HH:mm:ss"))
            }
        }
    }

    func onAppearEvent() {
        if self.weekDays.isEmpty {
            let currentWeek = Date.fetchWeek()
            weekDays.append(currentDate.fetchPreviousWeek())
            weekDays.append(currentWeek)
            weekDays.append(currentDate.fetchNextWeek())
        }

        if self.monthDays.isEmpty {
            let currentMonth = Date.fetchMonth()
            monthDays.append(currentDate.fetchPreviousMonth())
            monthDays.append(currentMonth)
            monthDays.append(currentDate.fetchNextMonth())
        }
    }

    func isSameMonth(_ day1: Date,_ day2: Date) -> Int {
        var result: Int = 0
        let calendar = Calendar.current
        if calendar.component(.month, from: day1) == calendar.component(.month, from: day2) &&
            calendar.component(.year, from: day1) == calendar.component(.year, from: day2) {
            return result
        }
        if day1 < day2 {
            result = -1
        } else {
            result = 1
        }
        return result
    }

    func setShowData(_ data: Date.CalendarDay) {
        if data.date.isSameDay(currentDate) {
            if let getData = data.data as? [SomeData], !getData.isEmpty {
                self.showData = getData
            } else {
                self.showData = []
            }
        }
    }
}

#Preview {
    CalendarView()
        .onAppear(){
            initDataList()
        }
}


