//
//  PathManagerViewController.swift
//  PathLogger
//
//  Created by Eugen Pirogoff on 27/03/15.
//  Copyright (c) 2015 Eugen Pirogoff. All rights reserved.
//

import UIKit

class PathManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  let dateFormatter = NSDateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    dateFormatter.dateStyle = .ShortStyle
    dateFormatter.timeStyle = .ShortStyle
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func backAction() {
    if self.presentingViewController != nil {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.reloadData()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("pathcell") as! UITableViewCell
    let path = PathStore.sharedInstance.loadPathAt(indexPath.row)
    var distance = NSString()
    if path.distanceInMeter > 1000 {
      distance = NSString(format: "%.2f km", path.distanceInKilometer)
    } else {
      distance = NSString(format: "%.2f m", path.distanceInMeter)
    }
    cell.textLabel?.text = "\(dateFormatter.stringFromDate(path.startTimestamp)), \(distance)"
    return cell
  }
  
//  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//    tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    PathStore.sharedInstance.currentPath = PathStore.sharedInstance.loadPathAt(indexPath.row)
//    self.backAction()
//  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return PathStore.sharedInstance.count
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//    if PathStore.sharedInstance.allPaths.count == 0 { return }
    if editingStyle == UITableViewCellEditingStyle.Delete {
      PathStore.sharedInstance.removePathAt(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
    }
  }
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return UITableViewCellEditingStyle.Delete
  }

  func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
    
  }
//  func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//    if PathStore.sharedInstance.allPaths.count == 0 {
//      return false
//    } else {
//      return true
//    }
//  }
  
}
