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

    var hasMusic: Bool

    @State private var isPresented = false
    @State private var isEditable = false
    @State private var message: Message?
    @State private var newTitle = ""
    @State private var cardWidth = CGFloat.zero
    @State private var cardHeight = CGFloat.zero

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
        self.hasMusic = performance.music.title != "_" ? true : false
    }

    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    VStack(alignment: .leading, spacing: 0) {
                        if hasMusic {
                            buildFetchMusicView()
                        } else {
                            buildFetchStateView("music.note")
                        }
                        buildMusicInfoView()
                    }

                    if isMyPerformance {
                        buildEditButton()
                    }
                }
                .onAppear {
                    cardWidth = geometry.size.width
                    cardHeight = geometry.size.height
                }
            }
            .aspectRatio(163/198, contentMode: .fit)
            .background(Gradient.blueGradation2)
            .foregroundStyle(Color.monoWhite3)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private func buildFetchMusicView() -> some View {
        return AsyncImage(url: performance.music.albumCoverURL) { phase in
            switch phase {
            case .empty:
                buildLodingView()
            case .success(let image):
                buildAlbumCoverView(image: image)
            case .failure:
                buildFetchStateView("exclamationmark.circle.fill")
            @unknown default:
                buildFetchStateView("exclamationmark.circle.fill")
            }
        }
    }

    private func buildLodingView() -> some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                FodiProgressView()
                Spacer()
            }
        }
        .frame(height: cardHeight)
    }

    private func buildAlbumCoverView(image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(height: cardHeight * 0.7)
            .clipped()
    }

    private func buildFetchStateView(_ image: String) -> some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Image(systemName: image)
                    .font(.title)
                Spacer()
            }
        }
        .frame(height: cardHeight * 0.7)
        .background(Color.monoWhite1)
    }

    private func buildMusicInfoView() -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("\(performance.title ?? "")")
                    .bold()

                Text(hasMusic
                     ? "\(performance.music.title)"
                     :"선택한 노래없음"
                )
                .font(.caption2)
            }
            .lineLimit(1)
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.monoWhite3)
                    .frame(width: cardWidth * 0.16, height: cardWidth * 0.16)

                Text("\(performance.headcount)")
                    .foregroundStyle(Color.blueDark)
                    .bold()
            }
        }
        .font(.footnote)
        .padding(.horizontal, 13)
        .frame(height: cardHeight * 0.3)
    }

    private func buildEditButton() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isPresented = true
                } label: {
                    Image("ellipsis")
                        .padding(.vertical, 12)
                        .padding(.horizontal)
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
            }
            Spacer()
        }
        .frame(width: cardWidth, height: cardHeight)
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
