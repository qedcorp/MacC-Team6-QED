//
//  DefaultSearchMusicRepository.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

import MusicKit

class DefaultSearchMusicRepository: SearchMusicRepository {

    private var recentTerm: String = ""
    private var songCache: [Music] = []

    func searchMusic(term: String, countPerPage: Int = 10, page: Int = 0) async throws -> [Music] {
        if MusicAuthorization.currentStatus != .authorized {
            let newStatus = await MusicAuthorization.request()

            if newStatus != .authorized {
                return []
            }
        }

        var request = MusicCatalogSearchRequest(term: term, types: [Song.self])
        request.limit = countPerPage
        request.offset = countPerPage * page

        if recentTerm != term {
            recentTerm = term
            songCache = []
        }

        guard let reponse = try? await request.response() else {
            print("can't search term : (\(term)")
            return []
        }
        print(reponse.songs)
        songCache.append(
            contentsOf: reponse.songs.map {
                $0.music
            }
        )

        return songCache
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
