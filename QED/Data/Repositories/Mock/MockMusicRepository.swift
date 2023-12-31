// Created by byo.

import Foundation

class MockMusicRepository: MusicRepository {

    private var musics: [Music]

    init(musics: [Music] = []) {
        self.musics = [Music(id: "", title: "sdsd", artistName: "sdsd"), Music(id: "", title: "cute", artistName: "sdsd")]
    }

    func readMusic(id: String) async throws -> Music {
        guard let music = musics.first(where: { $0.id == id }) else {
            throw DescribableError(description: "Cannot find a music.")
        }
        return music
    }

    func readMusics(keyword: String) async throws -> [Music] {
        musics.filter { $0.title.lowercased().contains(keyword.lowercased()) }
    }

    func readLyrics(music: Music) async throws -> Music.Lyric {
        Music.Lyric(startMs: 0, endMs: 0, words: "")
    }

}
