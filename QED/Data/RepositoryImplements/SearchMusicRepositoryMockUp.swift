//
//  SearchMusicRepositoryMockUp.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import Foundation

class SearchMusicRepositoryMockUp: SearchMusicRepository {
    
    let dummyMusicArray = [Music(id: "-1", title: "New Jeans", artistName: "New Jeans")]
    
    func searchMusic(term: String) async throws -> [Music] {
        return dummyMusicArray
    }
}

