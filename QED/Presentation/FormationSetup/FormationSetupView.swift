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
                        MusicHeadcountView(title: viewStore.music.title, headcount: viewStore.headcount)
                            .padding(.bottom, 16)
                        buildMemoView(viewStore: viewStore)
                            .modifier(DisabledOpacityModifier(
                                isDisabled: !viewStore.isEnabled,
                                disabledOpacity: 0.3
                            ))
                        Spacer(minLength: 18)
                        buildObjectCanvasView(viewStore: viewStore, width: geometry.size.width)
                            .modifier(DisabledOpacityModifier(
                                isDisabled: !viewStore.isEnabled,
                                disabledOpacity: 0.3
                            ))
                        Spacer()
                    }
                }
                .padding(.horizontal, 22)
                VStack(spacing: 0) {
                    buildPresetContainerView(viewStore: viewStore)
                    buildFormationContainerView(viewStore: viewStore)
                }
            }
            .ignoresSafeArea(.keyboard)
            .overlay(
                viewStore.isMemoFormPresented ?
                buildMemoFormView(viewStore: viewStore)
                : nil
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    PerformanceSetupTitleView(step: 1, title: "대형짜기")
                }
                ToolbarTitleMenu {
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("다음") {
                        MemberSetupView(store: .init(initialState: MemberSetupReducer.State(
                            performance: viewStore.performance
                        )) {
                            MemberSetupReducer()
                        })
                    }
                }
            }
            .onChange(of: viewStore.currentFormationIndex) { _ in
                guard let formable = viewStore.currentFormation else {
                    return
                }
                objectCanvasViewController.copyFormable(formable)
            }
            .onAppear {
                objectCanvasViewController.onChange = {
                    viewStore.send(.formationChanged($0))
                }
                viewStore.send(.viewAppeared)
            }
        }
    }

    private func buildMemoView(viewStore: ViewStore) -> some View {
        FormationMemoView(memo: viewStore.currentFormation?.memo)
            .onTapGesture {
                viewStore.send(.memoTapped)
            }
    }

    private func buildMemoFormView(viewStore: ViewStore) -> some View {
        MemoFormView(
            memo: viewStore.currentFormation?.memo ?? "",
            onSubmit: {
                viewStore.send(.currentMemoChanged($0))
            },
            onDismiss: {
                viewStore.send(.setMemoFormPresented(false))
            }
        )
    }

    private func buildObjectCanvasView(viewStore: ViewStore, width: CGFloat) -> some View {
        let height = width * CGFloat(22 / Float(35))
        return VStack(spacing: 6) {
            ObjectCanvasView(
                controller: objectCanvasViewController,
                headcount: viewStore.headcount
            )
            .frame(width: width, height: height)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.1))
            )
            .clipped()
            HStack {
                HistoryControlsView(historyManagable: objectCanvasViewController.historyManager)
                Spacer()
            }
        }
    }

    private func buildPresetContainerView(viewStore: ViewStore) -> some View {
        PresetContainerView(
            objectCanvasViewController: objectCanvasViewController,
            headcount: viewStore.headcount
        )
    }

    private func buildFormationContainerView(viewStore: ViewStore) -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.white)
                .frame(height: 106)
            VStack(spacing: 0) {
                buildFormationAddButton(viewStore: viewStore, buttonLength: 52)
                ZStack {
                    if viewStore.formations.isEmpty {
                        Text("프레임을 추가한 후 가사와 대형을 설정하세요.")
                            .foregroundStyle(.green)
                    }
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
            ObjectStageView(formable: formation)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.1))
                )
                .overlay(
                    index == viewStore.currentFormationIndex ?
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(.green, lineWidth: 1)
                    : nil
                )
                .clipped()
            Text(formation.memo ?? "대형 \(index + 1)")
                .font(.caption)
                .lineLimit(1)
        }
        .aspectRatio(41 / 32, contentMode: .fit)
        .contextMenu {
            ControlGroup {
                Button("삭제") {
                    viewStore.send(.formationDeleteButtonTapped(index))
                }
                Button("복제") {
                    viewStore.send(.formationDuplicateButtonTapped(index))
                }
            }
            .controlGroupStyle(.compactMenu)
        }
        .onTapGesture {
            viewStore.send(.formationTapped(index))
        }
    }
}
