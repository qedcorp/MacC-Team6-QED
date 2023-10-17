// Created by byo.

import Foundation

struct DefaultMusicUseCase: MusicUseCase {
    let musicRepository: MusicRepository

    func getMusic(id: String) async throws -> Music {
        try await musicRepository.readMusic(id: id)
    }

    func searchMusics(keyword: String) async throws -> [Music] {
        try await musicRepository.readMusics(keyword: keyword)
    }

    func getLyric(at targetMs: Int, of music: Music) async throws -> Music.Lyric? {
        guard let lyrics = music.lyrics else {
            return nil
        }
        return lyrics.first(where: { $0.msRange.contains(targetMs) })
    }
}
