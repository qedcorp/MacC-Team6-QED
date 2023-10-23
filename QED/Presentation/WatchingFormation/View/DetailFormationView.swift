//
//  WatchingDetailFormationView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct DetailFormationView: View {
    var performance: Performance
    var formation: Formation
//    @State var currentFormation: Formation
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = DetailFormationViewModel()
    @State var isNameVisiable = false
    @State var isPlaying = false

//    init() {
//        currentFormation = formation
//    }

    var body: some View {
        VStack {
            FormationPreview(
                performance: performance,
                formation: formation,
                isNameVisiable: isNameVisiable
            )
            Spacer()
            HStack {
                Button {
//                    currentFormation = viewModel.backward(
//                        performance: performance,
//                        currentFormation: currentFormation)
                } label: {
                    Image(systemName: "backward.fill")
                        .foregroundColor(.green)
                        .font(.title)
                }
                Button {
                    isPlaying.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 60, height: 60)
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                Button {
//                    currentFormation = viewModel.forward(
//                        performance: performance,
//                        currentFormation: currentFormation)
                } label: {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.green)
                        .font(.title)
                }
            }

        }
        .navigationBarBackButtonHidden()
        .navigationTitle(performance.title ?? "")
        .toolbar {
            leftItem
            rightItem
        }
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.green)
            }
        }
    }

    private var rightItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
//                TODO: 상세 동선 수정 기능
            } label: {
                Text("상세/수정")
                    .foregroundStyle(.green)
            }
        }
    }

}

#Preview {
    DetailFormationView(performance: mockPerformance,
                        formation: mockFormations[0])
}
