//
//  PerformanceListCardView.swift
//  QED
//
//  Created by OLING on 10/28/23.
//

import SwiftUI

@MainActor
struct PerformanceListCardView: View {
    var performance: PerformanceModel
    @ObservedObject var viewModel: PerformanceListReadingViewModel
    let isMyPerformance: Bool
    let onUpdate: ((String, String) -> Void)?
    let index: Int?

    @State private var isMusic = true
    @State private var isPresented = false
    @State private var isEditable = false
    @State private var message: Message?
    @State private var newTitle = ""

    init(performance: Performance,
         viewModel: PerformanceListReadingViewModel? = nil,
         isMyPerformance: Bool = false,
         index: Int? = nil,
         onUpdate: @escaping ((String, String) -> Void) = { _, _ in }) {
        self.performance = .build(entity: performance)
        self.viewModel = viewModel ?? PerformanceListReadingViewModel(performances: [performance])
        self.isMyPerformance = isMyPerformance
        self.index = index
        self.onUpdate = onUpdate
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if isMusic {
                    buildFetchMusicView()
                } else {
                    buildNoMusicView()
                }
                buildMusicInfoView()
                Spacer().padding()
            }

            if isMyPerformance {
                buildEditButton()
            }
        }
        .frame(width: 163, height: 198)
        .background(Gradient.blueGradation2)
        .foregroundStyle(Color.monoWhite3)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func buildFetchMusicView() -> some View {
        AsyncImage(url: performance.music.albumCoverURL) { phase in
            switch phase {
            case.empty:
                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        FodiProgressView()
                        Spacer()
                    }
                }
                .padding(.top, 20)
            case.success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case.failure:
                buildFetchFailureView()
            @unknown default:
                buildFetchFailureView()
            }
        }
        .frame(height: 170)
    }

    private func buildFetchFailureView() -> some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.title)
                Spacer()
            }
        }
        .padding(.top, 20)
    }

    private func buildNoMusicView() -> some View {
        // TODO: 여기에 이제 노래없을때 빈화면 넣으면 됨
        Rectangle()
            .frame(height: 170)
    }

    private func buildMusicInfoView() -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("\(performance.title ?? "")")
                    .bold()
                    .opacity(0.8)
                    .padding(.bottom, 1)

                Text(isMusic
                     ?"\(performance.music.title)"
                     :"선택한 노래없음"
                )
                .font(.caption2)
                .opacity(0.6)
            }
            .lineLimit(1)
            .truncationMode(.tail)

            Spacer()

            Text("\(performance.headcount)")
                .foregroundStyle(Color.blueDark)
                .bold()
                .background(
                    Circle()
                        .fill(Color.monoWhite3)
                        .frame(width: 27, height: 27)
                )
        }
        .font(.footnote)
        .padding(.top, 5)
        .padding(.horizontal, 30)
    }

    private func buildEditButton() -> some View {
        VStack {
            Spacer()
            Button {
                isPresented = true
            } label: {
                Image("ellipsis")
            }
            .confirmationDialog(
                "EditPerformance", isPresented: $isPresented, actions: {
                    buildConfirmationDialog()
                }
            )
            .alert(with: $message)
            .alert("프로젝트 이름 수정", isPresented: $isEditable) {
                buildTextFeildAlertView()
            }
            Spacer()
        }
        .padding(.leading, 125)
        .padding(.bottom, 150)
    }

    private func buildConfirmationDialog() -> some View {
        VStack {
            Button("삭제", role: .destructive) {
                if let index = index {
                    viewModel.selectDeletion(index: index, performanceID: performance.id)
                    message = viewModel.message.first
                }
            }
            Button("이름 수정") {
                isEditable = true
            }
            Button("취소", role: .cancel) {}
        }
    }

    private func buildTextFeildAlertView() -> some View {
        VStack {
            if let title = self.performance.title {
                TextField(title, text: $newTitle)
                    .foregroundStyle(.black)
                Button("완료", action: {
                    guard let onUpdate = onUpdate else { return }
                    onUpdate(performance.id, newTitle)
                    newTitle = ""
                })
                Button("취소", role: .cancel) {
                    newTitle = ""
                }
            }
        }
    }
}
