// Created by byo.

import Foundation

extension Music {
    enum Stub {
        static let newJeans = Music(
            id: "newjeans",
            title: "New Jeans",
            artistName: "NewJeans",
            // swiftlint:disable:next line_length
            albumCoverURL: URL(string: "https://i.namu.wiki/i/dEKxQWVYwv-mM1-YLFzSe9XnnLyrbPuRiwGOyPq4fGLsLWBKaVfibGEVh0YWznPBSxoqQCpF4_LxB8go91rcIAmL13eHWyRONaIJx2i1z8pEgzZA_QYLm6UIzhkrMW05141-puDvF1OsDyd7LM_x2A.webp"),
            durationMs: 109000,
            lyrics: [
                Lyric(startMs: 0, endMs: 1000, words: "Look it's a new me"),
                Lyric(startMs: 1000, endMs: 2000, words: "Switched it up, who's this?"),
                Lyric(startMs: 2000, endMs: 3000, words: "우릴 봐 NewJeans"),
                Lyric(startMs: 3000, endMs: 4000, words: "So fresh, so clean")
            ]
        )
    }
}
