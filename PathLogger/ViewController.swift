//
//  ViewController.swift
//  PathLogger
//
//  Created by Eugen Pirogoff on 27/03/15.
//  Copyright (c) 2015 Eugen Pirogoff. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var recSwitch: UISwitch!
  @IBOutlet weak var centerButton: UIButton!
  @IBOutlet weak var controlsView: UIVisualEffectView!
  
  var locationmanager : CLLocationManager?
  let pathstore: PathStore = PathStore.sharedInstance
//  let act = Interactor.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initCL()
    initMK()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
//    if let viewedPath = pathstore.currentPath {
//      mapView.addOverlay(viewedPath.polyline)
//    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    if let overlays = mapView.overlays {
      mapView.removeOverlays(overlays)
    }
  }

  @IBAction func recAction(sender: UISwitch) {
    if sender.on {
      initCL()
      startCL()
      pathstore.createPath()
    } else {
      stopCL()
      pathstore.savePath()
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
//    if let location = locations.last as? CLLocation {
//      self.pathstore.currentPath?.addLocation(location)
//      mapView.removeOverlay(self.pathstore.currentPath?._oldPolyline)
//      mapView.addOverlay(self.pathstore.currentPath?.polyline)
//    }
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
