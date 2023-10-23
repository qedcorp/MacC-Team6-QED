// Created by byo.

import SwiftUI

struct MemberSetupFormationView: View {
    let index: Int
    let formation: FormationModel
    let colorHex: String?
    @State private var objectSelectionViewController = ObjectSelectionViewController()

    var body: some View {
        VStack(spacing: 10) {
            ObjectSelectionView(controller: objectSelectionViewController)
                .aspectRatio(35 / 22, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.1))
                )
            Text(formation.memo ?? "대형 \(index + 1)")
                .foregroundStyle(.green)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.1))
                )
        }
        .onChange(of: formation) {
            objectSelectionViewController.copyFormable($0)
        }
        .onChange(of: colorHex) {
            objectSelectionViewController.colorHex = $0
        }
        .onAppear {
            objectSelectionViewController.copyFormable(formation)
        }
    }
}
