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
//  MeasurementExtensions.swift
//  SwiftUtilities
//

import Foundation

#if canImport(CoreGraphics)
import CoreGraphics
#endif

extension Measurement {
    public init(value: CGFloat, unit: UnitType) {
        self.init(value: Double(value), unit: unit)
    }
    
    public init(value: Int, unit: UnitType) {
        self.init(value: Double(value), unit: unit)
    }
}


extension UnitSpeed {
    static var milesPerMinute: UnitSpeed = UnitSpeed(symbol: "miles/minute", converter: UnitConverterLinear(coefficient: 0.0372823))
    static var kmPerMinute: UnitSpeed = UnitSpeed(symbol: "km/minute", converter: UnitConverterLinear(coefficient: 0.06))
}
