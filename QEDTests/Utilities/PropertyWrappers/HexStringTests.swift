// Created by byo.

import XCTest
@testable import QED

final class HexStringTests: XCTestCase {
    class MockData {
        @HexString
        var value: String
        
        init(value: String) {
            self.value = value
        }
    }
    
    var sut: MockData!

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testValidValue() {
        // given
        let value = "123456"
        sut = MockData(value: value)
        
        // then
        XCTAssertEqual(sut.value, value)
    }
    
    func testInvalidValue() {
        // given
        let value = "QWERTY"
        sut = MockData(value: value)
        
        // then
        XCTAssertNotEqual(sut.value, value)
    }
}
