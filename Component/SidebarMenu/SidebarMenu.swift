//
//  SidebarMenu.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/11.
//

import SwiftUI
//sidebar menu view
struct SidebarMenu: View {
    //show menu
    @State private var showMenu: Bool = false
    var body: some View {
        VStack{
            HStack{
                
            }
            Circle()
                .onTapGesture {
                    self.showMenu = true
                }
        }
    }


}

#Preview {
    SidebarMenu()
}

