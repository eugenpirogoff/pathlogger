import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var recSwitch: UISwitch!
  @IBOutlet weak var centerButton: UIButton!
  @IBOutlet weak var controlsView: UIVisualEffectView!
  
  var locationmanager : CLLocationManager?
  let pathstore = PathStore.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initCL()
    initMK()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    updateViewedOverlays()
    setRegionToViewedPath()
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
  }

  @IBAction func recAction(sender: UISwitch) {
    if sender.on {
      initCL()
      startCL()
      pathstore.startRecording()
    } else {
      stopCL()
      pathstore.stopRecording()
    }
  }

  @IBAction func centerAction(sender: UIButton) {
    mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    UIView.animateWithDuration(0.4, animations: {
      self.centerButton.alpha = 0.0
    })
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    if let touch = touches.first as? UITouch {
      if !CGRectContainsPoint(self.controlsView.frame, touch.locationInView(self.view)) {
        mapView.setUserTrackingMode(MKUserTrackingMode.None, animated: true)
        UIView.animateWithDuration(0.4, animations: {
          self.centerButton.alpha = 1.0
        })
      }
    }
    super.touchesBegan(touches, withEvent: event)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "PathManagerSegue") {
//      let pathManagerViewController = segue.destinationViewController as! PathManagerViewController
//        pathManagerViewController.pathmanager = self.pathmanager
    }
  }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
  func initCL() {
    locationmanager = CLLocationManager()
    locationmanager!.delegate = self
    locationmanager!.requestWhenInUseAuthorization()
  }
  
  func startCL() {
    locationmanager!.requestAlwaysAuthorization()
    locationmanager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationmanager!.activityType = .Fitness
    locationmanager!.pausesLocationUpdatesAutomatically = true
    locationmanager!.distanceFilter = 10
    locationmanager!.startUpdatingLocation()
  }
  
  func stopCL() {
    locationmanager!.stopUpdatingLocation()
    locationmanager = nil
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    if let location = locations.last as? CLLocation {
      pathstore.addLocation(location)
      updateViewedOverlays()
    }
  }
  
  func updateViewedOverlays(){
    mapView.removeOverlays(mapView.overlays)
    if let vp = pathstore.viewedPath {
        mapView.addOverlay(vp.polyline)
    }
  }
  
  func setRegionToViewedPath(){
    if let vp = pathstore.viewedPath {
      let rect = vp.polyline.boundingMapRect
      let region = MKCoordinateRegionForMapRect(rect)
      mapView.setRegion(region, animated: true)
    }
  }
}

// MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
  func initMK(){
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.userLocation.title = "You are here!"
    mapView.userTrackingMode = .Follow
  }
  
  func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
    if overlay is MKPolyline {
      var polylineRenderer = MKPolylineRenderer(overlay: overlay)
      polylineRenderer.strokeColor = UIColor.orangeColor()
      polylineRenderer.lineWidth = 4.5
      return polylineRenderer
    }
    return nil
  }
}
