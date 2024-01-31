//
//  TimeLine.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/5.
//

import SwiftUI

struct TimeLineView: View {
    @State private var dataList: [SomeData] = []

    var body: some View {
        VStack{
            TimeLineView()
        }
        .onAppear{
            onAppearEvent()

        }
    }

    @ViewBuilder
    func TimeLineView() -> some View {
        if self.dataList.count != 0 {
            ScrollViewReader { scrollViewProxy in
                ScrollView{
                    ForEach(self.dataList) { item in
                        Text(item.title)
                            .padding(.leading,20)
                            .padding(.top,15)
                            .hSpacing(.leading)
                    }
                }
                .frame(maxHeight: 600)
                .background(.yellow,in: .rect(cornerRadius: 20))
                .padding(12)


            }
        } else {
            Text("no data")
        }
    }

    

    func onAppearEvent() {
        initDataList()
        self.dataList = initTimeLineData()
    }

}

#Preview {
    TimeLineView()
}

