// Created by byo.

import Foundation

class Music: Identifiable, Equatable, Playable {
    let id: String
    let title: String
    let artistName: String
    let albumCoverURL: URL?
    let durationMs: Int?
    let lyrics: [Lyric]?

    init(
        id: String,
        title: String,
        artistName: String,
        albumCoverURL: URL? = nil,
        durationMs: Int? = nil,
        lyrics: [Lyric]? = nil
    ) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.albumCoverURL = albumCoverURL
        self.durationMs = durationMs
        self.lyrics = lyrics
    }

    var creator: String {
        artistName
    }

    var thumbnailURL: URL? {
        albumCoverURL
    }
  
    static func == (lhs: Music, rhs: Music) -> Bool {
        lhs.id == rhs.id
    }

    struct Lyric: Codable {
        let startMs: Int
        let endMs: Int
        let words: String

        var msRange: ClosedRange<Int> {
            startMs ... endMs
        }
    }
}
