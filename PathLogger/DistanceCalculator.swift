import Foundation
import CoreLocation

class DistanceCalculator {
    
    let _path:[CLLocation]
    
    init(path: [CLLocation]){
        self._path = path
    }
    
    func distanceInMeter() -> Double {
        var distance = 0.0
        
        for (index, position) in enumerate(self._path) {
            if index+1 < self._path.count{
                var to = self._path[index+1]
                distance += position.distanceFromLocation(to)
            }
        }
        return distance
    }
    
    func distanceInKilometer() -> Double {
        return self.distanceInMeter() / 1000
    }
}
