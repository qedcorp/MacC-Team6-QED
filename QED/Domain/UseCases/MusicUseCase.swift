// Created by byo.

import Foundation

protocol MusicUseCase {
    func getMusic(id: String) async throws -> Music
    func searchMusics(keyword: String) async throws -> [Music]
    func getLyric(at targetMs: Int, of music: Music) async throws -> Music.Lyric?
}
