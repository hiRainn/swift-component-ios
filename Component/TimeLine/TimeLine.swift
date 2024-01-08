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

    }
}

#Preview {
    TimeLineView()
}

