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
//  CLLocationExtensions.swift
//  SwiftUtilities
//

import Foundation
import CoreLocation

private var earthRadius = Measurement(value: 6371000.0, unit: UnitLength.meters)

private func normalize(heading: Double) -> Double {
    var x = fmod(heading, 360)
    if x < 0 {
        x = 360 + x
    }
    return x
}

@available(iOS 10, *)
extension CLLocationCoordinate2D {
    
    public func distance(to other: CLLocationCoordinate2D, unit: UnitLength = .meters) -> Measurement<UnitLength> {
        let lat1 = self.latitude.radians
        let lat2 = other.latitude.radians
        
        let lon1 = self.longitude.radians
        let lon2 = other.longitude.radians
        
        let d = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1))
        let distance = d * earthRadius.converted(to: unit).value
        return Measurement(value: distance, unit: unit)
    }
    
    public func bearing(to other: CLLocationCoordinate2D) -> Measurement<UnitAngle> {
        let lat1 = self.latitude.radians
        let lat2 = other.latitude.radians
        
        let lon1 = self.longitude.radians
        let lon2 = other.longitude.radians
        
        let y = sin(lon2 - lon1) * cos(lat2)
        
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1)
        
        let brng = atan2(y, x).degrees
        
        return Measurement(value: normalize(heading: brng), unit: .degrees)
    }
    
    public func midPoint(between other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let lat1 = self.latitude.radians
        let lat2 = other.latitude.radians
        let lon1 = self.longitude.radians
        let lon2 = other.longitude.radians
        
        let Bx = cos(lat2) * cos(lon2-lon1)
        let By = cos(lat2) * sin(lon2-lon1)
        let lat3 = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1)+Bx)*(cos(lat1)+Bx) + By*By))
        let lon3 = lon1 + atan2(By, cos(lat1) + Bx)
        
        return CLLocationCoordinate2D(latitude: lat3.degrees, longitude: lon3.degrees)
    }
    
    public func pointAt(bearing: Measurement<UnitAngle>, distance: Measurement<UnitLength>) -> CLLocationCoordinate2D {
        
        let t1 = self.latitude.radians
        let l1 = self.longitude.radians
        let brng = bearing.converted(to: .radians).value
        let d = distance.value
        let radius = earthRadius.converted(to: distance.unit).value
        let t2 = asin(sin(t1) * cos(d/radius) + cos(t1) * sin(d/radius) * cos(brng))
        let l2 = l1 + atan2(sin(brng) * sin(d/radius) * cos(t1), cos(d/radius) - sin(t1) * sin(t2))
        return CLLocationCoordinate2D(latitude: t2.degrees, longitude: l2.degrees)
    }
    
    public static func intersectionBetween(coordinate: CLLocationCoordinate2D, bearing: Measurement<UnitAngle>, otherCoordinate: CLLocationCoordinate2D, otherBearing: Measurement<UnitAngle>) -> CLLocationCoordinate2D? {
        let lat1 = coordinate.latitude.radians
        let lon1 = coordinate.longitude.radians
        let lat2 = otherCoordinate.latitude.radians
        let lon2 = otherCoordinate.longitude.radians
        
        let brng13 = bearing.converted(to: .radians).value
        let brng23 = otherBearing.converted(to: .radians).value

        var brng12: Double
        var brng21: Double

        let dLat = lat2 - lat1
        let dLon = lon2 - lon1

        let dist12 = 2 * asin(sqrt(sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2)))
        if dist12 == 0 {
            return nil // Same point
        }

        // initial/final bearings between points
        let brngA = acos((sin(lat2) - sin(lat1) * cos(dist12)) / (sin(dist12) * cos(lat1)))

        let brngB = acos((sin(lat1) - sin(lat2) * cos(dist12)) / (sin(dist12) * cos(lat2)))

        if sin(lon2 - lon1) > 0 {
            brng12 = brngA
            brng21 = 2 * Double.pi - brngB
        } else {
            brng12 = 2 * Double.pi - brngA
            brng21 = brngB
        }

        let alpha1 = fmod((brng13 - brng12 + Double.pi), (2 * Double.pi)) - Double.pi // angle 2-1-3
        let alpha2 = fmod((brng21 - brng23 + Double.pi), (2 * Double.pi)) - Double.pi // angle 1-2-3

        if sin(alpha1) == 0 && sin(alpha2) == 0 {
            return nil // infinite intersections
        } else if sin(alpha1) * sin(alpha2) < 0 {
            return nil // ambiguous intersection
        }

        let alpha3 = acos(-cos(alpha1) * cos(alpha2) + sin(alpha1) * sin(alpha2) * cos(dist12))
        let dist13 = atan2(sin(dist12) * sin(alpha1) * sin(alpha2), cos(alpha2) + cos(alpha1) * cos(alpha3))
        let latTemp = asin(sin(lat1) * cos(dist13) + cos(lat1) * sin(dist13) * cos(brng13))
        let dLon13 = atan2(sin(brng13) * sin(dist13) * cos(lat1), cos(dist13) - sin(lat1) * sin(latTemp))
        var lonTemp = lon1 + dLon13
        lonTemp = fmod((lonTemp + 3 * Double.pi), (2 * Double.pi)) - Double.pi // normalise to -180..+180Âº
        return CLLocationCoordinate2D(latitude: latTemp.degrees, longitude: lonTemp.degrees)
    }
}
