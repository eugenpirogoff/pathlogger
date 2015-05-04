//
//  Path.swift
//  PathLogger
//
//  Created by Eugen Pirogoff on 28/03/15.
//  Copyright (c) 2015 Eugen Pirogoff. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Path: Printable {
  
  var _path : [CLLocation]
  var _name : NSDate
  let _dateformatter : NSDateFormatter
  
  init(){
    _path = []
    _name = NSDate()
    _dateformatter = NSDateFormatter()
    _dateformatter.dateFormat = "yyyy-MM-dd"
  }
  
  func addLocation(new_location : CLLocation) {
    self._path.append(new_location)
  }
  
  func polyline() -> MKPolyline {
    var coords = self._path.map{$0.coordinate}
    return MKPolyline(coordinates: &coords, count: coords.count)
  }
  
  var name : String {
    return _dateformatter.stringFromDate(_name) as String
  }
  
  var distance : Double {
    return DistanceCalculator(path: self._path).distanceInKilometer()
  }
  
  var description : String {
    let distance_formated = NSString(format: "%.2f", self.distance)
    return "\(self.name), \(distance_formated) km"
  }
  
}

