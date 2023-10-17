// Created by byo.

import Foundation

class MockMusicRepository: MusicRepository {
    var musics: [Music]

    init(musics: [Music] = []) {
        self.musics = musics
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
}
