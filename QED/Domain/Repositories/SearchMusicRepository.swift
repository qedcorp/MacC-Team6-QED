//
//  SearchMusicRepository.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import Foundation

protocol SearchMusicRepository {
    func searchMusic(term: String, countPerPage: Int, page: Int) async throws -> [Music]
}
