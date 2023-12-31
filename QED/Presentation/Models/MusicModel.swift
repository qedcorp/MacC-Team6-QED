// Created by byo.

import Foundation

struct MusicModel: Equatable {
    let title: String
    let artistName: String
    let albumCoverURL: URL?

    static func build(entity: Music) -> Self {
        MusicModel(title: entity.title, artistName: entity.artistName, albumCoverURL: entity.albumCoverURL)
    }
}
