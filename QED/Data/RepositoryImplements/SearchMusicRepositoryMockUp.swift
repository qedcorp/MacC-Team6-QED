//
//  SearchMusicRepositoryMockUp.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import Foundation

class SearchMusicRepositoryMockUp: SearchMusicRepository {
    
    let dummyMusicArray = [Music(id: "0", title: "0", artistName: "0")]
    
    func searchMusic(term: String) async throws -> [Music] {
        return dummyMusicArray
    }
}
