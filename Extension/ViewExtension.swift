//
//  ViewExtension.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/2.
//

import SwiftUI

extension View {
    func hSpacer(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity,alignment: alignment)
    }

    func vSpacer(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: alignment)
    }
}

