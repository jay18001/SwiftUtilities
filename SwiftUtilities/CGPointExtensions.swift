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
//  CGPointExtensions.swift
//  SwiftUtilities
//

import Foundation
import CoreGraphics

extension CGPoint {
    public func distance(to other: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - other.x, 2) + pow(self.y - other.y, 2))
    }
    
    public func midPoint(between other: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x + other.x)/2, y: (self.y + other.y)/2)
    }
    
    public func angle(to other: CGPoint) -> Measurement<UnitAngle> {
        if other.x > self.x {//above 0 to 180 degrees
            return Measurement(value: Double(atan2((other.x - self.x), (self.y - other.y))), unit: .radians)
        } else if other.x < self.x {//above 180 degrees to 360/0
            return Measurement(value: Double((CGFloat.pi * 2) - atan2((self.x - other.x), (self.y - other.y))), unit: .radians)
        }
        return Measurement(value: 0.0, unit: .radians)
    }
}
