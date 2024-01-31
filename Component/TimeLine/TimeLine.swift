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
                    VStack {
                        ForEach(self.dataList) { item in
                            TimeLineItem(item)
                        }
                    }.padding([.top,.leading],20)

                }
                .hSpacing(.leading)
                .frame(maxHeight: 600)
                .background(.yellow,in: .rect(cornerRadius: 20))
                .padding(12)


            }
        } else {
            Text("no data")
        }
    }

    @ViewBuilder
    func TimeLineItem(_ item: SomeData) -> some View {
        HStack(alignment: .top,spacing: 15) {
            Circle()
                .fill(.blue)
                .frame(width: 10,height: 10)
                .background(.white.shadow(.drop(color:.black.opacity(0.1),radius: 3)))

        }
        .hSpacing(.leading)
    }

    

    func onAppearEvent() {
        initDataList()
        self.dataList = initTimeLineData()
    }

}

#Preview {
    TimeLineView()
}

