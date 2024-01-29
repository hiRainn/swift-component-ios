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
            let _ = print(2)

        }
    }

    @ViewBuilder
    func TimeLineView() -> some View {
        ForEach(self.dataList) { item in
            Text(item.title)
        }
        let _ = print(3)  
    }

    

    func onAppearEvent() {
        self.dataList = initTimeLineData()
    }

}

#Preview {
    TimeLineView()
        .onAppear(){
            initDataList()
            let _ = print(1)
        }
}

