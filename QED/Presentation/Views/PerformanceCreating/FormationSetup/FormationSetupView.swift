// Created by byo.

import ComposableArchitecture
import SwiftUI

struct FormationSetupView: View {
    fileprivate typealias Reducer = FormationSetupReducer
    fileprivate typealias ViewStore = ViewStoreOf<Reducer>

    private let store: StoreOf<Reducer>
    private let objectCanvasViewController: ObjectCanvasViewController
    private let performanceSettingManager: PerformanceSettingManager
    private let performanceUseCase: PerformanceUseCase
    @State private var yame = 0

    init(
        performance: Performance,
        performanceUseCase: PerformanceUseCase
    ) {
        let objectCanvasViewController = ObjectCanvasViewController()
        let performanceSettingManager = PerformanceSettingManager(
            performance: performance,
            sizeable: objectCanvasViewController.view
        )
        self.store = .init(initialState: Reducer.State(performance: performance)) {
            Reducer(performanceUseCase: performanceUseCase)
        }
        self.objectCanvasViewController = objectCanvasViewController
        self.performanceSettingManager = performanceSettingManager
        self.performanceUseCase = performanceUseCase
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 26) {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        MusicHeadcountView(
                            title: viewStore.music.title,
                            headcount: viewStore.headcount
                        )
                        .padding(.bottom, 16)
                        MemoButton(viewStore: viewStore)
                        Spacer(minLength: 18)
                        ObjectCanvas(
                            viewStore: viewStore,
                            width: geometry.size.width,
                            objectCanvasViewController: objectCanvasViewController
                        )
                        Spacer()
                    }
                }
                .padding(.horizontal, 22)
                VStack(spacing: 0) {
                    PresetContainer(
                        viewStore: viewStore,
                        objectCanvasViewController: objectCanvasViewController
                    )
                    FormationContainer(viewStore: viewStore)
                }
            }
            .ignoresSafeArea(.keyboard)
            .overlay(
                viewStore.isMemoFormPresented ?
                MemoForm(viewStore: viewStore)
                : nil
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    PerformanceSetupTitleView(
                        step: 1,
                        title: "대형짜기"
                    )
                }
                ToolbarTitleMenu {
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("다음") {
                        MemberSetupView(
                            performanceSettingManager: performanceSettingManager,
                            performanceUseCase: performanceUseCase
                        )
                        .tag(yame)
                    }
                    .disabled(!viewStore.isAvailableToSave)
                }
            }
        }
    }

    private struct MemoButton: View {
        let viewStore: ViewStore

        var body: some View {
            MemoButtonView(memo: viewStore.currentFormation?.memo)
                .modifier(DisabledOpacityModifier(
                    isDisabled: !viewStore.isAvailableToEdit,
                    disabledOpacity: 0.3
                ))
                .onTapGesture {
                    viewStore.send(.memoButtonTapped)
                }
        }
    }

    private struct ObjectCanvas: View {
        let viewStore: ViewStore
        let width: CGFloat
        let objectCanvasViewController: ObjectCanvasViewController

        var height: CGFloat {
            width * CGFloat(22 / Float(35))
        }

        var body: some View {
            VStack(spacing: 6) {
                ObjectCanvasView(
                    controller: objectCanvasViewController,
                    headcount: viewStore.headcount,
                    onChange: { _ in }
                )
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.1))
                )
                .clipped()
                HStack {
                    HistoryControlsView(historyManagable: objectCanvasViewController.objectCanvasHistoryManager)
                    Spacer()
                }
            }
            .modifier(DisabledOpacityModifier(
                isDisabled: !viewStore.isAvailableToEdit,
                disabledOpacity: 0.3
            ))
        }
    }

    private struct PresetContainer: View {
        let viewStore: ViewStore
        let objectCanvasViewController: ObjectCanvasViewController

        var body: some View {
            PresetContainerView(
                objectCanvasViewController: objectCanvasViewController,
                headcount: viewStore.headcount
            )
            .modifier(DisabledOpacityModifier(
                isDisabled: !viewStore.isAvailableToEdit,
                disabledOpacity: 0.3
            ))
        }
    }

    private struct FormationContainer: View {
        let viewStore: ViewStore

        var body: some View {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.white)
                    .frame(height: 106)
                VStack(spacing: 0) {
                    FormationAddButton(viewStore: viewStore)
                    ZStack {
                        if viewStore.formations.isEmpty {
                            Text("프레임을 추가한 후 가사와 대형을 설정하세요.")
                                .foregroundStyle(.green)
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(
                                    Array(viewStore.formations.enumerated()),
                                    id: \.offset
                                ) { formationOffset, formation in
                                    FormationItem(
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
    }

    private struct FormationAddButton: View {
        let viewStore: ViewStore
        private let buttonLength: CGFloat = 52

        var body: some View {
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
    }

    private struct FormationItem: View {
        let viewStore: ViewStore
        let index: Int
        let formation: FormationModel

        var body: some View {
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

    private struct MemoForm: View {
        let viewStore: ViewStore

        var body: some View {
            MemoFormView(
                memo: viewStore.currentFormation?.memo ?? "",
                onSubmit: { viewStore.send(.currentMemoChanged($0)) },
                onDismiss: { viewStore.send(.setMemoFormPresented(false)) }
            )
        }
    }
}
