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
            timeLineData(createAt: Date.setDate("2014-01-06") ?? Date(), title: "title1", content: "conten1", isFinish: false, tagColor: "red"),
            timeLineData(createAt: Date.setDate("2014-01-06") ?? Date(), title: "title1", content: "conten1", isFinish: false, tagColor: "red"),
        ]
    }

}

#Preview {
    TimeLineView()
}

