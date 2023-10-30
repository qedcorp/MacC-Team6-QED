// Created by byo.

import Foundation

protocol MusicRepository {
    func readMusic(id: String) async throws -> Music
    func readMusics(keyword: String) async throws -> [Music]
    func readLyrics(music: Music) async throws -> Music.Lyric
}
