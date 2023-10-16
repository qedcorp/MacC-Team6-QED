//
//  SearchMusicRepository.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import Foundation

protocol SearchMusicRepository {
    func searchMusic(term: String) async throws -> [Music]
}

