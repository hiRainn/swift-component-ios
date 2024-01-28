//
//  MockData.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/23.
//

import SwiftUI

struct SomeData: Identifiable {
    var id: UUID = .init()
    var title: String
    var content: String
    var createAt: Date
    var isFinish: Bool = false
    var finishAt: Date? = nil
    var tagColor: Color = Color.white
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
