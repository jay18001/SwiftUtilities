## SwiftUtilities

### Some helpful utilities for Swift

<details><summary>CLLocationCoordinate2D</summary>
<p>

#### Distance to another Coordinate

```swift
public func distance(to other: CLLocationCoordinate2D, unit: UnitLength = default) -> Measurement<UnitLength>
```

#### Bearing to another Coordinate

```swift
 public func bearing(to other: CLLocationCoordinate2D) -> Measurement<UnitAngle>
```

#### Midpoint between another Coordinate

```swift
public func midPoint(between other: CLLocationCoordinate2D) -> CLLocationCoordinate2D
```

#### Coordinate at bearing and distance

```swift
public func pointAt(bearing: Measurement<UnitAngle>, distance: Measurement<UnitLength>) -> CLLocationCoordinate2D
```

#### Intersection between to bearings

```swift
public static func intersectionBetween(coordinate: CLLocationCoordinate2D, bearing: Measurement<UnitAngle>, otherCoordinate: CLLocationCoordinate2D, otherBearing: Measurement<UnitAngle>) -> CLLocationCoordinate2D?
```
</p>
</details>

<details><summary>String</summary>
<p>

#### Split string with regex groups

```swift
public func split(regex pattern: String) throws -> [Substring]
```
</p>
</details>

### Contributing
Feel free to create a PR

### License
MIT
