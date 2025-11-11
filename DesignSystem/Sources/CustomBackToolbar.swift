//
//  SwiftUI.swift
//  Showcase
//
//  Created by 백래훈 on 10/24/25.
//

import SwiftUI

public struct CustomBackToolbar: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    var onBack: (() -> Void)?

    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if let onBack { onBack() }
                        else { dismiss() }
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                    }
                    .tint(.white)
                }
            }
    }
}

public extension View {
    func customBackToolbar(onBack: (() -> Void)? = nil) -> some View {
        modifier(CustomBackToolbar(onBack: onBack))
    }
}
