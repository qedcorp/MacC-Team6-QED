//
//  DefaultMusicRepository.swift
//  QED
//
//  Created by changgyo seo on 10/27/23.
//

import Foundation

import MusicKit

struct DefaultMusicRepository: MusicRepository {

    func readMusic(id: String) async throws -> Music {
        Music(id: "", title: "", artistName: "")
    }

    func readMusics(keyword: String) async throws -> [Music] {
        if MusicAuthorization.currentStatus != .authorized {
            let newStatus = await MusicAuthorization.request()

            if newStatus != .authorized {
                return []
            }
        }

        var request = MusicCatalogSearchRequest(term: keyword, types: [Song.self])
        request.limit = 10
        guard let reponse = try? await request.response() else {
            print("can't search keyword : (\(keyword)")
            return []
        }
        return reponse.songs.map { $0.music }
    }

    func readLyrics(music: Music) async throws -> Music.Lyric {
        Music.Lyric(startMs: 0, endMs: 0, words: "")
    }
}

fileprivate extension Song {
    var music: Music {
        Music(
            id: id.rawValue,
            title: title,
            artistName: artistName,
            albumCoverURL: artwork?.url(width: 1024, height: 1024),
            durationMs: Int((duration ?? 0) * 10000),
            lyrics: []
        )
    }
}
