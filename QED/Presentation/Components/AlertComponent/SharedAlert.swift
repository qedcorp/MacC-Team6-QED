//
//  SharedAlert.swift
//  QED
//
//  Created by changgyo seo on 1/19/24.
//

import SwiftUI

struct SharedAlert: View {

    var pId: String
    var music: MusicModel

    @State private var isShowingKakaoTalk = false
    @State private var offsetY: CGFloat = -64
    private let cornerRadius: CGFloat = 12

    var body: some View {
        ZStack {
            VStack(spacing: 34) {
                Text("팀원들에게 동선표를 공유해보세요!")
                    .foregroundStyle(Color(.blueLight3))
                    .font(.system(size: 20, weight: .semibold))
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .foregroundStyle(Color(UIColor(hex: "767680").withAlphaComponent(0.24)))
                            .frame(width: 268, height: 42)
                        Text("\(pId)")
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .foregroundStyle(Color(UIColor(hex: "B0B0B8")))
                            .frame(width: 244, height: 42)
                    }
                    Button {
                        UIPasteboard.general.setValue("www.formationdirector.com?pId=\(pId)", forPasteboardType: "public.plain-text")
                        ToastContainerViewModel.shared.presentMessage("공유주소가 복사되었습니다")
                    } label: {
                        Image(systemName: "square.on.square")
                            .resizable()
                            .foregroundStyle(Color(UIColor(hex: "B0B0B8")))
                            .frame(width: 24, height: 24)
                    }
                }
                Image("KakaoSharedButton")
                    .frame(width: 307, height: 54)
                    .onTapGesture {
                        isShowingKakaoTalk = true
                    }
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Gradient.strokeGlass2)
            )
            .mask {
                RoundedRectangle(cornerRadius: cornerRadius)
            }
            .offset(y: offsetY)
            if isShowingKakaoTalk {
                KakaoSharedView(pId: pId, musicModel: music)
            }
        }
        .onAppear {
            animate(.interpolatingSpring) {
                offsetY = 0
            }
        }
    }
}

struct Previewvv: PreviewProvider {
    static var previews: some View {
        SharedAlert(pId: "asda", music: MusicModel(title: "", artistName: "", albumCoverURL: nil))
    }
}
