// Created by byo.

import XCTest
@testable import QED

final class MinMaxTests: XCTestCase {
    class MockData {
        @MinMax(minValue: 0, maxValue: 100)
        var value: Int
        
        init(value: Int) {
            self.value = value
        }
    }
    
    var sut: MockData!
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testValidValue() {
        // given
        let value = 50
        sut = MockData(value: value)
        
        // then
        XCTAssertEqual(sut.value, value)
    }
    
    func testInvalidIfLessThenMinValue() {
        // given
        let value = -1
        sut = MockData(value: value)
        
        // then
        XCTAssertNotEqual(sut.value, value)
    }
    
    func testInvalidIfGreaterThenMaxValue() {
        // given
        let value = 101
        sut = MockData(value: value)
        
        // then
        XCTAssertNotEqual(sut.value, value)
    }
}
