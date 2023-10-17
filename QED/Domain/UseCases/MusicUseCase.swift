// Created by byo.

import Foundation

protocol MusicUseCase {
    func getMusic(id: String) async throws -> Music
    func searchMusics(keyword: String) async throws -> [Music]
}
