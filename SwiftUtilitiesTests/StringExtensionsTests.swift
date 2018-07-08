//
// Copyright (c) 2018 Mountain Buffalo Limited
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software
// is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  StringExtensionsTests.swift
//  SwiftUtilitiesTests
//

import Foundation
import SwiftUtilities
import XCTest

class StringExtensionsTests: XCTestCase {

    func testSubstingRegex() throws {
        
        let str = "123E ZET"
        let parts = try str.split(regex: "([0-9]{0,3})([NSEW]{0,3}) ([A-Z]{0,3})")
        XCTAssertTrue(parts.count == 3)
        XCTAssertEqual(parts[0], "123")
        XCTAssertEqual(parts[1], "E")
        XCTAssertEqual(parts[2], "ZET")
    }
    
    func testSubstingRegexNonMatching() throws {
        let str = "The quick brown fox jumps over the lazy dog"
        let parts = try str.split(regex: "([0-9]{0,3})([NSEW]{0,3}) ([A-Z]{0,3})")
        XCTAssertTrue(parts.isEmpty)
    }
}
