//
//  SearchMusicRepositoryMockUp.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import Foundation

class SearchMusicRepositoryMockUp: SearchMusicRepository {

    private let dummyMusicArray = Array(repeating: Music(id: "0", title: "0", artistName: "0"), count: 10)

    func searchMusic(term: String, countPerPage: Int = 10, page: Int = 1) async throws -> [Music] {
        return dummyMusicArray
    }
}
