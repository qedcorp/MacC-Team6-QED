// Created by byo.

import SwiftUI

struct FormationManageView: View {
    let objectCanvasViewController = ObjectCanvasViewController()

    var body: some View {
        VStack(spacing: 26) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    buildMusicHeadcountView()
                        .padding(.bottom, 16)
                    buildLyricView()
                    Spacer(minLength: 18)
                    buildObjectCanvasView(width: geometry.size.width)
                    Spacer()
                }
            }
            .padding(.horizontal, 22)
            VStack(spacing: 28) {
                buildPresetContainerView()
                buildFormationContainerView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                buildTitleView()
            }
            ToolbarTitleMenu {
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("다음") {
                }
            }
        }
    }

    private func buildTitleView() -> some View {
        HStack(spacing: 6) {
            Text("STEP 1")
                .foregroundColor(.white)
                .font(.caption2.weight(.heavy))
                .frame(height: 20)
                .padding(.horizontal, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.green)
                )
            Text("대형짜기")
                .font(.headline)
        }
    }

    private func buildMusicHeadcountView() -> some View {
        HStack(spacing: 6) {
            Text("PINK VENOM")
                .foregroundColor(.gray)
                .font(.caption2.weight(.semibold))
            Text("4인")
                .foregroundColor(.gray)
                .font(.caption2)
                .frame(height: 20)
                .padding(.horizontal, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.gray.opacity(0.1))
                )
        }
    }

    private func buildLyricView() -> some View {
        HStack(alignment: .center) {
            Spacer()
            Text("가사 어쩌구")
            Spacer()
        }
        .frame(height: 46)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.gray.opacity(0.1))
        )
    }

    private func buildObjectCanvasView(width: CGFloat) -> some View {
        let height = width * CGFloat(22 / Float(35))
        return VStack(spacing: 6) {
            ObjectCanvasView(controller: objectCanvasViewController)
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.1))
                )
            HStack {
                HistoryControlsView(historyManagable: objectCanvasViewController.historyManager)
                Spacer()
            }
        }
    }

    private func buildPresetContainerView() -> some View {
        PresetContainerView(
            presetUseCase: DefaultPresetUseCase(
                presetRepository: LocalPresetRepository()
            ),
            objectCanvasViewController: objectCanvasViewController
        )
    }

    private func buildFormationContainerView() -> some View {
        let buttonLength: CGFloat = 52
        return ZStack(alignment: .top) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1 ..< 10) { index in
                        buildFormationItemView(index: index)
                    }
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
            .padding(.top, buttonLength / 2)
            buildCirclePlusButton(buttonLength: buttonLength)
        }
        .frame(height: 106)
        .background(.white)
        .shadow(color: .black.opacity(0.1), radius: 2, y: -2)
    }

    private func buildCirclePlusButton(buttonLength: CGFloat) -> some View {
        Button {
        } label: {
            Circle()
                .foregroundColor(.green)
                .frame(width: buttonLength)
                .aspectRatio(contentMode: .fit)
                .overlay(
                    Circle()
                        .strokeBorder(.white, lineWidth: 6)
                )
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: buttonLength / 2, weight: .bold))
                )
                .offset(y: -buttonLength / 2)
        }
    }

    private func buildFormationItemView(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.gray.opacity(0.1))
                .frame(width: 82, height: 52)
            Text("대형 \(index)")
                .font(.caption)
        }
    }
}

struct FormationManageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormationManageView()
        }
    }
}
