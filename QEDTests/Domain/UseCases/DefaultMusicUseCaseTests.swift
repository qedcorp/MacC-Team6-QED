// Created by byo.

import XCTest
@testable import QED

final class DefaultMusicUseCaseTests: XCTestCase {
    static let sampleMusics: [Music] = ["sample", "stub", "dummy"]
        .map { Music(id: $0, title: $0.capitalized, artistName: $0) }

    var sut: DefaultMusicUseCase!
    var musicRepository: MockMusicRepository!

    override func setUpWithError() throws {
        musicRepository = MockMusicRepository()
        sut = DefaultMusicUseCase(musicRepository: musicRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        musicRepository = nil
    }

    func testSuccessWhenGetMusic() async throws {
        // given
        let id = "sample"
        musicRepository.musics = Self.sampleMusics

        // when
        let music = try await sut.getMusic(id: id)

        // then
        XCTAssertEqual(music.id, id)
    }

    func testFailureWhenGetMusicWithWrongId() async throws {
        // given
        musicRepository.musics = Self.sampleMusics

        // when
        let music = try? await sut.getMusic(id: "test")

        // then
        XCTAssertNil(music)
    }

    func testSuccessWhenSearchMusics() async throws {
        // given
        musicRepository.musics = Self.sampleMusics

        // when
        let musics = try await sut.searchMusics(keyword: "s")

        // then
        XCTAssertEqual(musics.map { $0.id }, ["sample", "stub"])
    }

    func testSuccessWhenGetLyric() async throws {
        // given
        let music = Music.Stub.newJeans

        // when
        let lyric = try await sut.getLyric(at: 2500, of: music)

        // then
        XCTAssertEqual(lyric?.words, "우릴 봐 NewJeans")
    }

    func testFailureWhenGetLyricAtNone() async throws {
        // given
        let music = Music.Stub.newJeans

        // when
        let lyric = try await sut.getLyric(at: 5000, of: music)

        // then
        XCTAssertNil(lyric)
    }
}
