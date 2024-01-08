//
//  TimeLineData.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/5.
//

import SwiftUI

struct timeLineData: Identifiable {
    var id: UUID = .init()
    var createAt: Date
    var title: String
    var content: String
    var isFinish: Bool
    var tagColor: String
}


