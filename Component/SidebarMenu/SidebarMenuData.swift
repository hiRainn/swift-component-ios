//
//  SidebarMenuData.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/11.
//

import SwiftUI


struct SidebarData: Identifiable{
    var id: UUID = .init()
    var title: String
    var link: String 
}

func initSidebarData() -> [SidebarData] {
    var sidebar: [SidebarData] = [
        SidebarData(title: "title1", link: "link1"),
        SidebarData(title: "title2", link: "link2"),
        SidebarData(title: "title3", link: "link3"),
        SidebarData(title: "title4", link: "link4"),
        SidebarData(title: "title5", link: "link5"),
    ]
    return sidebar
}
