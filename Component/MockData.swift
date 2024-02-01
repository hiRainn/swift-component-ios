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

let SelfColor: [Color] = [
    Color(red: 247/255, green: 247/255, blue: 144/255),
    Color(red: 187/255, green: 255/255, blue: 255/255),
    Color(red: 160/255, green: 214/255, blue: 160/255),
    Color(red: 221/255, green: 119/255, blue: 221/255),
    Color(red: 235/255, green: 122/255, blue: 122/255),
    Color(red: 105/255, green: 105/255, blue: 201/255),
    Color(red: 255/255, green: 250/255, blue: 250/255),
]

//mock database data
func initDataList() {
    //mock 3 * 30 days' data
    for i in 0...30 {
        //random num data
        for  randomInt in 0...Int.random(in: 1...20) {
            let colorIndex: Int = Int.random(in: 0...6)
            let data: SomeData = SomeData(title: "title" + String(randomInt), content: "concent" + today.getSomeDayAfter(i * 3)!.format("yyyy-MM-dd"), createAt: today.getSomeDayAfter(i * 3)!,tagColor: SelfColor[colorIndex])
            DataList.append(data)
        }
        for  randomInt in 0...Int.random(in: 1...20) {
            let colorIndex: Int = Int.random(in: 0...6)
            let data: SomeData = SomeData(title: "title" + String(randomInt), content: "concent" + today.getSomeDayAfter(-i * 3)!.format("yyyy-MM-dd"), createAt: today.getSomeDayAfter(-i * 3)!,tagColor: SelfColor[colorIndex])
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
