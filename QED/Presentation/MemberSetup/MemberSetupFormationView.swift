// Created by byo.

import SwiftUI

struct MemberSetupFormationView: View {
    let formation: FormationModel
    @State private var objectCanvasViewController = ObjectCanvasViewController()

    var body: some View {
        ZStack(alignment: .bottom) {
            ObjectCanvasView(controller: objectCanvasViewController)
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
        .onAppear {
            objectCanvasViewController.copyFormable(formation)
        }
        .onChange(of: formation) {
            objectCanvasViewController.copyFormable($0)
        }
    }
}
