// Created by byo.

import Foundation

class MockMusicRepository: MusicRepository {
    private static let musics: [Music] = ["sample", "stub", "dummy"]
        .map { Music(id: $0, title: $0.capitalized, artistName: $0) }
    
    func readMusic(id: String) async throws -> Music {
        guard let music = Self.musics.first(where: { $0.id == id }) else {
            fatalError("Cannot find a music.")
        }
        return music
    }
    
    func readMusics(keyword: String) async throws -> [Music] {
        Self.musics
            .filter { $0.title.lowercased().contains(keyword.lowercased()) }
    }
}
