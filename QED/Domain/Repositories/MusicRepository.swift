// Created by byo.

import Foundation

protocol MusicRepository {
    func readMusic(id: String) async throws -> Music
    func readMusics(keyword: String) async throws -> [Music]
    func readLyrics(title: String, artist: String) async throws -> Music.Lyric
}
