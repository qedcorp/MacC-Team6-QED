//
//  SearchMusicRepositoryTests.swift
//  QEDTests
//
//  Created by changgyo seo on 10/17/23.
//

import XCTest
@testable import QED

final class SearchMusicRepositoryTests: XCTestCase {

    var sut: SearchMusicRepository!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSearchMusicRepository_모든기본데이터가0인더미배열배출() async throws{
        // given
        let predictedValue = [Music(id: "0", title: "0", artistName: "0")]
        sut = SearchMusicRepositoryMockUp()
        
        // when
        let returnValue = try await sut.searchMusic(term: "", countPerPage: 0, page: 0)
        
        // then
        XCTAssertEqual(predictedValue, returnValue)
    }
}

extension Music: Equatable {
    public static func == (lhs: Music, rhs: Music) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.artistName == rhs.artistName
    }
}
