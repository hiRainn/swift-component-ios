//
//  ContentView.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    CalendarView()
        .onAppear(){
            initDataList()
        }
}
