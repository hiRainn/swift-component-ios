//
//  TimeLine.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/5.
//

import SwiftUI

struct TimeLineView: View {
    @State private var dataList: [timeLineData] = []

    var body: some View {
        VStack{

        }
        .onAppear{
            onAppearEvent()
        }
    }

    func onAppearEvent() {
        self.dataList = [
            timeLineData(createAt: Date.setDate("2014-01-06") ?? Date(), title: "title1", content: "conten1", isFinish: false, tagColor: .red),
            timeLineData(createAt: Date.setTime("2014-01-06 10:12:11") ?? Date(), title: "title1", content: "conten1", isFinish: false, tagColor: .green),
            timeLineData(createAt: Date.setTime("2014-01-08 10:12:11") ?? Date(), title: "title1", content: "conten1", isFinish: false, tagColor: .green),
            timeLineData(createAt: Date.setTime("2014-01-12 10:12:11") ?? Date(), title: "title1", content: "conten1", isFinish: false, tagColor: .green),
        ]
    }

}

#Preview {
    TimeLineView()
}

