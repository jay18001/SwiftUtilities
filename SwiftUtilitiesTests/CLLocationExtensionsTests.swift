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
//  CLLocationExtensionsTests.swift
//  SwiftUtilitiesTests
//

import CoreLocation
import SwiftUtilities
import XCTest

class CLLocationExtensionsTests: XCTestCase {

    func testDistanceBetweenPoints() {

        let coord1 = CLLocationCoordinate2D(latitude: 37.334385, longitude: -122.009026)
        let coord2 = CLLocationCoordinate2D(latitude: 37.421813, longitude: -122.083974)
        
        let distance = coord1.distance(to: coord2)
        XCTAssertEqual(distance.value, 11762, accuracy: 1)
    }
    
    func testBearingBetweenPoints() {
        let coord1 = CLLocationCoordinate2D(latitude: 37.334385, longitude: -122.009026)
        let coord2 = CLLocationCoordinate2D(latitude: 37.421813, longitude: -122.083974)
        
        let bearing = coord1.bearing(to: coord2)
        XCTAssertEqual(bearing.converted(to: .degrees).value, 325, accuracy: 1)
    }
    
    func testMidPointBetweenPoints() {
        let coord1 = CLLocationCoordinate2D(latitude: 37.334385, longitude: -122.009026)
        let coord2 = CLLocationCoordinate2D(latitude: 37.421813, longitude: -122.083974)
        
        let midPoint = coord1.midPoint(between: coord2)
        XCTAssertEqual(midPoint.latitude, 37.378056, accuracy: 0.0001)
        XCTAssertEqual(midPoint.longitude, -122.046389, accuracy: 0.0001)
    }
    
    func testPointAtDistance() {
        let coord1 = CLLocationCoordinate2D(latitude: 37.334385, longitude: -122.009026)
        
        let midPoint = coord1.pointAt(bearing: Measurement(value: 325, unit: .degrees), distance: Measurement(value: 11762, unit: .meters))
        XCTAssertEqual(midPoint.latitude, 37.421008, accuracy: 0.0001)
        XCTAssertEqual(midPoint.longitude, -122.08542, accuracy: 0.0001)
    }
    
    func testIntersection() {
        let coord1 = CLLocationCoordinate2D(latitude: 37.767917, longitude: -122.486949)
        let coord2 = CLLocationCoordinate2D(latitude: 37.905529, longitude: -122.270743)
        
        let intersection = CLLocationCoordinate2D.intersectionBetween(coordinate: coord1, bearing: Measurement(value: 119, unit: .degrees), otherCoordinate: coord2, otherBearing: Measurement(value: 195, unit: .degrees))!
        XCTAssertEqual(intersection.latitude, 37.7030718, accuracy: 0.0001)
        XCTAssertEqual(intersection.longitude, -122.63459, accuracy: 0.0001)
    }
    
    func testSameCoordinateIntersection() {
        let coord1 = CLLocationCoordinate2D(latitude: 37.0, longitude: -121.0)
        let coord2 = CLLocationCoordinate2D(latitude: 37.0, longitude: -121.0)
        
        let intersection = CLLocationCoordinate2D.intersectionBetween(coordinate: coord1, bearing: Measurement(value: 119, unit: .degrees), otherCoordinate: coord2, otherBearing: Measurement(value: 119, unit: .degrees))
        XCTAssertNil(intersection)
    }
    
    func testNoIntersection() {
        let coord1 = CLLocationCoordinate2D(latitude: 37.767917, longitude: -122.486949)
        let coord2 = CLLocationCoordinate2D(latitude: 37.905529, longitude: -122.270743)
        
        let intersection = CLLocationCoordinate2D.intersectionBetween(coordinate: coord1, bearing: Measurement(value: 119, unit: .degrees), otherCoordinate: coord2, otherBearing: Measurement(value: 300, unit: .degrees))
        XCTAssertNil(intersection)
    }
}
