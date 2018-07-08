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
//  StringExtensions.swift
//  SwiftUtilities
//

import Foundation

extension String {
    public func split(regex pattern: String) throws -> [Substring] {
        let regex = try NSRegularExpression(pattern: pattern)
        let result = regex.matches(in: self, range: NSMakeRange(0, self.utf16.count))
        guard !result.isEmpty else {
            return []
        }
        var values: [Substring] = []
        for i in 1...regex.numberOfCaptureGroups {
            let range = result[0].range(at: i)
            let startIndex = self.index(self.startIndex, offsetBy: range.location)
            let endIndex = self.index(startIndex, offsetBy: range.length)
            let value = self[startIndex..<endIndex]
            if !value.isEmpty {
                values.append(value)
            }
        }
        
        return values
    }
}
