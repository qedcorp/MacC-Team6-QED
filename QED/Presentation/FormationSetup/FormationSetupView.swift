// Created by byo.

import ComposableArchitecture
import SwiftUI

struct FormationSetupView: View {
    private typealias ViewStore = ViewStoreOf<FormationSetupReducer>

    let store: StoreOf<FormationSetupReducer>
    private let objectCanvasViewController = ObjectCanvasViewController()

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 26) {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        buildMusicHeadcountView(viewStore: viewStore)
                            .padding(.bottom, 16)
                        buildLyricView(viewStore: viewStore)
                        Spacer(minLength: 18)
                        buildObjectCanvasView(width: geometry.size.width)
                        Spacer()
                    }
                }
                .padding(.horizontal, 22)
                VStack(spacing: 0) {
                    buildPresetContainerView()
                    buildFormationContainerView(viewStore: viewStore)
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
            .onAppear {
                viewStore.send(.viewAppeared)
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

    private func buildMusicHeadcountView(viewStore: ViewStore) -> some View {
        HStack(spacing: 6) {
            Text(viewStore.music.title)
                .foregroundColor(.gray)
                .font(.caption2.weight(.semibold))
            Text("\(viewStore.headcount)인")
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

    private func buildLyricView(viewStore: ViewStore) -> some View {
        HStack(alignment: .center) {
            Spacer()
            Text(viewStore.currentMemo ?? "클릭해서 가사 입력")
                .lineLimit(1)
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
        PresetContainerView(objectCanvasViewController: objectCanvasViewController)
    }

    private func buildFormationContainerView(viewStore: ViewStore) -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.white)
                .frame(height: 106)
            VStack(spacing: 0) {
                buildFormationAddButton(viewStore: viewStore, buttonLength: 52)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(viewStore.formations.enumerated()), id: \.offset) { formationOffset, formation in
                            buildFormationItemView(
                                viewStore: viewStore,
                                index: formationOffset,
                                formation: formation
                            )
                        }
                        Spacer()
                    }
                    .frame(height: 64)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 14)
                }
            }
        }
        .shadow(color: .black.opacity(0.1), radius: 2, y: -2)
    }

    private func buildFormationAddButton(
        viewStore: ViewStore,
        buttonLength: CGFloat
    ) -> some View {
        Button {
            viewStore.send(.formationAddButtonTapped)
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
        }
    }

    private func buildFormationItemView(
        viewStore: ViewStore,
        index: Int,
        formation: FormationModel
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.gray.opacity(0.1))
                .overlay(
                    index == viewStore.currentFormationIndex ?
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(.green, lineWidth: 1)
                    : nil
                )
            Text(formation.memo ?? "대형 \(index + 1)")
                .font(.caption)
                .lineLimit(1)
        }
        .aspectRatio(41 / 32, contentMode: .fit)
        .onTapGesture {
            viewStore.send(.formationTapped(index))
        }
    }
}
