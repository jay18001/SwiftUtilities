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
//  CGLineSegment.swift
//  SwiftUtilities
//

import Foundation
import CoreGraphics

public struct CGLineSegment {
    public var point1: CGPoint
    public var point2: CGPoint
    
    public var midPoint: CGPoint {
        return CGPoint(x: (point1.x + point2.x)/2, y: (point1.y + point2.y)/2)
    }
    
    public var length: CGFloat {
        return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
    
    public var angle: Measurement<UnitAngle> {
        if self.point2.x > self.point1.x {//above 0 to 180 degrees
            return Measurement(value: atan2((self.point2.x - self.point1.x), (self.point1.y - self.point2.y)), unit: .radians)
        } else if self.point2.x < self.point1.x {//above 180 degrees to 360/0
            return Measurement(value: (CGFloat.pi * 2) - atan2((self.point1.x - self.point2.x), (self.point1.y - self.point2.y)), unit: .radians)
        }
        return Measurement(value: 0.0, unit: .radians)
    }
    
    public mutating func scale(by amount: CGFloat) {
        let d = fabs(sqrt(pow(self.point1.x-self.point2.x, 2) + pow(self.point1.y - self.point2.y, 2)))
        let p = (d + amount)/d
        
        let rise = (self.point1.y - self.point2.y) * p
        let run = (self.point1.x - self.point2.x) * p
        point2 = CGPoint(x: self.point2.x + run, y: self.point2.y + rise)
    }
    
    public func scaled(by amount: CGFloat) -> CGLineSegment {
        let d = fabs(sqrt(pow(self.point1.x-self.point2.x, 2) + pow(self.point1.y - self.point2.y, 2)))
        let p = (d + amount)/d
        
        let rise = (self.point1.y - self.point2.y) * p
        let run = (self.point1.x - self.point2.x) * p
        
        return CGLineSegment(point1: point1, point2: CGPoint(x: self.point2.x+run, y: self.point2.y+rise))
    }
    
    public func isOnSegment(point: CGPoint) -> Bool {
        return point.x <= max(point1.x, point2.x) && point.x >= max(point1.x, point2.x) &&
            point.y <= max(point1.y, point2.y) && point.y >= max(point1.y, point2.y)
    }
    
    public func intersects(_ other: CGLineSegment) -> Bool {
        enum Orientation {
            case colinear
            case clockwise
            case counterclockwise
        }
        
        func orientation(p: CGPoint, q: CGPoint, r: CGPoint) -> Orientation {
            // See http://www.geeksforgeeks.org/orientation-3-ordered-points/
            // for details of below formula.
            let val = (q.y - p.y) * (r.x - q.x) -
                (q.x - p.x) * (r.y - q.y)
            
            if val == 0 { return .colinear }
            
            return val > 0 ? .clockwise : .counterclockwise // clock or counterclock wise
        }
        
        // Find the four orientations needed for general and
        // special cases
        let o1 = orientation(p: self.point1, q: other.point1, r: self.point2)
        let o2 = orientation(p: self.point1, q: other.point1, r: other.point2)
        let o3 = orientation(p: self.point2, q: other.point2, r: self.point1)
        let o4 = orientation(p: self.point2, q: other.point2, r: other.point1)
        
        // General case
        if (o1 != o2 && o3 != o4) {
            return true
        }
        
        // Special Cases
        // self.point1, other.point1 and self.point2 are colinear and self.point2 lies on segment self.point1-other.point1
        if o1 == .colinear && CGLineSegment(point1: self.point1, point2: other.point1).isOnSegment(point: self.point2) { return true }
        
        // self.point1, other.point1 and self.point2 are colinear and other.point2 lies on segment self.point1-other.point1
        if o2 == .colinear && CGLineSegment(point1: self.point1, point2: other.point1).isOnSegment(point: other.point2) { return true }
        
        // self.point2, other.point2 and self.point1 are colinear and self.point1 lies on segment self.point2-other.point2
        if o3 == .colinear && CGLineSegment(point1: self.point2, point2: other.point2).isOnSegment(point: self.point2) { return true }
        
        // self.point2, other.point2 and other.point1 are colinear and other.point1 lies on segment self.point2-other.point2
        if o4 == .colinear && CGLineSegment(point1: self.point2, point2: other.point2).isOnSegment(point: other.point2) { return true }
        
        return false // Doesn't fall in any of the above cases
    }
    
    public func intersects(rect: CGRect) -> Bool {
        // Find min and max X for the segment
        
        var minX = min(point1.x, point2.x)
        var maxX = max(point1.x, point2.x)
        
        // Find the intersection of the segment's and rectangle's x-projections
        if maxX > rect.maxX {
            maxX = rect.maxX
        }
        
        if minX < rect.minX {
            minX = rect.minX
        }
        
        if minX > maxX { // If their projections do not intersect return false
            return false
        }
        
        // Find corresponding min and max Y for min and max X we found before
        var minY = point1.y
        var maxY = point2.y
        
        let dx = self.point2.x - self.point1.x
        
        if fabs(dx) > 0.0000001 {
            let a = (self.point2.y - self.point1.y) / dx
            let b = self.point1.y - a * self.point1.x
            minY = a * minX + b
            maxY = a * maxX + b
        }
        
        if minY > maxY {
            let tmp = maxY
            maxY = minY
            minY = tmp
        }
        
        // Find the intersection of the segment's and rectangle's y-projections
        if maxY > rect.maxY {
            maxY = rect.maxY
        }
        
        if minY < rect.minY {
            minY = rect.minY
        }
        
        if minY > maxY { // If Y-projections do not intersect return false
            return false
        }
        
        return true
    }
}

extension CGLineSegment {
    
    public init(origin: CGPoint, distance: CGFloat, angle: Measurement<UnitAngle>) {
        
        let run = cos(angle.converted(to: .radians).value) * distance
        let rise = sin(angle.converted(to: .radians).value) * distance
        self.point1 = origin
        self.point2 = CGPoint(x: origin.x + run, y: origin.y + rise)
    }
}

