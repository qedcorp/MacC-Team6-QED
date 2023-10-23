// Created by byo.

import SwiftUI

struct MemberSetupFormationView: View {
    let formation: FormationModel
    let colorHex: String?
    @State private var objectSelectionViewController = ObjectSelectionViewController()

    var body: some View {
        ZStack(alignment: .bottom) {
            ObjectSelectionView(controller: objectSelectionViewController)
                .aspectRatio(35 / 22, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.gray.opacity(0.1))
                )
            Text(formation.memo ?? "")
                .foregroundStyle(.white)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(maxWidth: .infinity, maxHeight: 36)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.green)
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
