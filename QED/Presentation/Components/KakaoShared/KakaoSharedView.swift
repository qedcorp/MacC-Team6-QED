//
//  KakaoSharedView.swift
//  QED
//
//  Created by changgyo seo on 1/19/24.
//

import SwiftUI

struct KakaoSharedView: UIViewControllerRepresentable {

    var pId: String
    var musicModel: MusicModel

    func makeUIViewController(context: Context) -> KakaoSharedViewController {
        return KakaoSharedViewController(
            musicTitle: musicModel.title,
            albumCoverURL: musicModel.albumCoverURL?.absoluteString,
            pId: pId
        )
    }

    func updateUIViewController(_ uiViewController: KakaoSharedViewController, context: Context) {

    }
}
