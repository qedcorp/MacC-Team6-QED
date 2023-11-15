//
//  ProgressView.swift
//  QED
//
//  Created by OLING on 11/15/23.
//

import SwiftUI

struct ProgressView: View {
    @State var isRotating = 0.0

    var body: some View {
        Image("Progress")
            .rotationEffect(.degrees(isRotating))
            .onAppear {
                withAnimation(.linear(duration: 1)
                    .speed(0.25).repeatForever(autoreverses: false)) {
                        isRotating = 360.0
                    }
            }
    }
}

#Preview {
    ProgressView()
}
