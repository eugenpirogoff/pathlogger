import Foundation
import CoreLocation
import CoreData
import MapKit

class Path: NSManagedObject, Printable {
    
    @NSManaged var path : Array<CLLocation>
    @NSManaged var startTimestamp: NSDate
    @NSManaged var endTimestamp: NSDate
    @NSManaged var distance: NSNumber
    
    var duration: NSTimeInterval {
        get {
            return endTimestamp.timeIntervalSinceDate(startTimestamp)
        }
    }
    
    var distanceInMeter : Double {
        get {
            return DistanceCalculator(path: path).distanceInMeter()
        }
    }
    
    var distanceInKilometer : Double {
        get {
            return DistanceCalculator(path: path).distanceInKilometer()
        }
    }
    
    var polyline: MKPolyline? {
        get{
            var coords = self.path.map{$0.coordinate}
            if coords.count > 1 {
                return MKPolyline(coordinates: &coords, count: coords.count)
            } else {
                let line : MKPolyline? = nil
                return line
            }
        }
    }
    
    func addLocation(location: CLLocation) {
        self.path.append(location)
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        path = [CLLocation]()
        startTimestamp = NSDate()
    }
}
