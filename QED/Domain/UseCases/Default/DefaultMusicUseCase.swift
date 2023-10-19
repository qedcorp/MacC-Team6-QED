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
}
