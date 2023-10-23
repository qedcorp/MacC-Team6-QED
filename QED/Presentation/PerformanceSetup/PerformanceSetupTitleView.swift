// Created by byo.

import SwiftUI

struct PerformanceSetupTitleView: View {
    let step: Int
    let title: String

    var body: some View {
        HStack(spacing: 6) {
            Text("STEP \(step)")
                .foregroundColor(.white)
                .font(.caption2.weight(.heavy))
                .frame(height: 20)
                .padding(.horizontal, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.green)
                )
            Text(title)
                .font(.headline)
        }
    }
}

#Preview {
    PerformanceSetupTitleView(step: 0, title: "")
}
