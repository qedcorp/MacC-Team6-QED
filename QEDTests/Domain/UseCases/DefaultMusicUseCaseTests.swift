// Created by byo.

import XCTest
@testable import QED

final class DefaultMusicUseCaseTests: XCTestCase {
    static let musics: [Music] = ["sample", "stub", "dummy"]
        .map { Music(id: $0, title: $0.capitalized, artistName: $0) }

    var sut: DefaultMusicUseCase!
    var musicRepository: MusicRepository!

    override func setUpWithError() throws {
        musicRepository = MockMusicRepository(musics: Self.musics)
        sut = DefaultMusicUseCase(musicRepository: musicRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        musicRepository = nil
    }

    func testSuccessWhenGetMusic() async throws {
        // given
        let id = "sample"

        // when
        let music = try await sut.getMusic(id: id)

        // then
        XCTAssertEqual(music.id, id)
    }

    func testFailureWhenGetMusicWithWrongId() async throws {
        // when
        let music = try? await sut.getMusic(id: "test")

        // then
        XCTAssertNil(music)
    }

    func testSuccessWhenSearchMusics() async throws {
        // when
        let musics = try await sut.searchMusics(keyword: "s")

        // then
        XCTAssertEqual(musics.map { $0.id }, ["sample", "stub"])
    }
}
