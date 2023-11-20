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
                VStack(spacing: 0) {
                    buildMusicImageView()
                    buildPerformanceInfoView()
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
        .foregroundStyle(Color.monoWhite3)
        .aspectRatio(163 / 198, contentMode: .fit)
        .background(Gradient.blueGradation2)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    private func buildMusicImageView() -> some View {
        ZStack {
            if hasMusic {
                buildFetchMusicView()
            } else {
                buildFetchStateView("music.note")
            }
            if !performance.isCompleted {
                Color.black.opacity(0.8)
                Image("yetComplete")
            }
        }
        .frame(height: cardHeight * 0.7)
        .clipped()
    }

    private func buildPerformanceInfoView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("\(performance.title ?? "")")
                    .font(.footnote.weight(.bold))
                Text(hasMusic
                     ? "\(performance.music.title)"
                     :"선택한 노래없음"
                )
                .font(.caption2)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.monoWhite3)
                    .frame(width: cardWidth * 0.165, height: cardWidth * 0.165)
                Text("\(performance.headcount)")
                    .foregroundStyle(Color.blueDark)
                    .font(.footnote.weight(.bold))
            }
        }
        .lineLimit(1)
        .padding(.leading, 13)
        .padding(.trailing, 12)
        .frame(height: cardHeight * 0.3)
        .background(.ultraThinMaterial)
    }

    private func buildFetchMusicView() -> some View {
        return AsyncImage(url: performance.music.albumCoverURL, transaction: .init(animation: .easeInOut)) { phase in
            switch phase {
            case .empty:
                buildLoadingView()
            case .success(let image):
                buildAlbumCoverView(image: image)
            case .failure:
                buildFetchStateView("exclamationmark.circle.fill")
            @unknown default:
                buildFetchStateView("exclamationmark.circle.fill")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.monoWhite2)
    }

    private func buildLoadingView() -> some View {
        ZStack {
            FodiProgressView()
        }
    }

    private func buildAlbumCoverView(image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .clipped()
    }

    private func buildFetchStateView(_ image: String) -> some View {
        ZStack {
            Image(systemName: image)
                .font(.title)
        }
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
                        .padding(.horizontal, 20)
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
                Button("완료") {
                    guard let onUpdate = onUpdate else { return }
                    onUpdate(performance.id, newTitle)
                    newTitle = ""
                }
                Button("취소", role: .cancel) {
                    newTitle = ""
                }
            }
        }
    }
}
