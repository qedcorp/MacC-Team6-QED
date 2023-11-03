//
//  TestPlayBar.swift
//  QED
//
//  Created by chaekie on 11/3/23.
//

import SwiftUI

enum Direct {
    case none
    case right
    case left

    var title: String {
        switch self {
        case .none: return "-"
        case .right: return "오른쪽"
        case .left: return "왼쪽"
        }
    }
}

struct TestPlayBar: View {
    private let data: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    @StateObject private var viewModel: ViewModel = ViewModel()

    private struct ScrollOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }

    private var scrollObservableView: some View {
        GeometryReader { proxy in
            let offsetX = proxy.frame(in: .global).origin.x
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetX
                )
                .onAppear {
                    viewModel.setOriginOffset(offsetX)
                }
        }
        .frame(height: 0)
    }

    var body: some View {
        VStack {
            HeaderView(direct: $viewModel.direct,
                       offset: $viewModel.offset)
            .onTapGesture {
                viewModel.offset += 150
            }
            ScrollView(.horizontal, showsIndicators: false) {
                scrollObservableView
                HStack(spacing: 0) {
                    ForEach(data, id: \.self) {
                        CellView(title: $0)
                    }
                }
                .offset(x: viewModel.offset)
            }
            .onPreferenceChange(ScrollOffsetKey.self) {
                print("dldldld")
                viewModel.setOffset($0)
            }
            Button("Play") {
                viewModel.play()
            }
        }
    }

    struct HeaderView: View {
        @Binding var direct: Direct
        @Binding var offset: CGFloat

        var body: some View {
            ZStack {
                Color.orange
                VStack {
                    Text("\(direct.title)으로 스크롤중")
                    Text("현재위치: \(offset)")
                }
            }
            .frame(height: 100)
        }
    }

    struct CellView: View {
        let title: String

        var body: some View {
            ZStack {
                Color.gray
                Text(title)
            }
            .frame(width: 94, height: 61)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

final class ViewModel: ObservableObject {
    @Published var offset: CGFloat = 0
    @Published var direct: Direct = .none
    @Published var previewWidth = CGFloat(94)
    var totalLength = 16

    private var originOffset: CGFloat = 0
    private var isCheckedOriginOffset: Bool = false

    func setOriginOffset(_ offset: CGFloat) {
        guard !isCheckedOriginOffset else { return }
        self.originOffset = offset
        self.offset = offset
        isCheckedOriginOffset = true
    }

    func setOffset(_ offset: CGFloat) {
        guard isCheckedOriginOffset else { return }
        if self.offset < offset {
            direct = .left
        } else if self.offset > offset {
            direct = .right
        } else {
            direct = .none
        }
        self.offset = offset
    }

    func play() {
        withAnimation(.linear(duration: TimeInterval(Int(previewWidth) * totalLength/50))) {
            offset -= CGFloat(Int(previewWidth) * totalLength)
        }
    }
}

#Preview {
    TestPlayBar()
}
