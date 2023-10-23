//
//  MockSearchMusicUseCase.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import Foundation

struct MockUpSearchMusicUseCase: MusicUseCase {
    let searchMusicRepository: SearchMusicRepository

    func getMusic(id: String) async throws -> Music {
        Music(id: "", title: "", artistName: "")
    }

    func searchMusics(keyword: String) async throws -> [Music] {
        guard let searchResult = try? await searchMusicRepository.searchMusic(term: keyword, countPerPage: 10, page: 0) else { return [] }

        return searchResult
    }

}
