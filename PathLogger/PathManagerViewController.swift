//
//  PathManagerViewController.swift
//  PathLogger
//
//  Created by Eugen Pirogoff on 27/03/15.
//  Copyright (c) 2015 Eugen Pirogoff. All rights reserved.
//

import UIKit

class PathManagerViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var pathmanager : PathManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func backAction(sender: UIButton) {
    if self.presentingViewController != nil {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}

// MARK: UITableViewDelegate
extension PathManagerViewController: UITableViewDelegate{
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("pathcell") as! UITableViewCell
    if let pathManager = self.pathmanager {
      let currentPath = pathManager.selectPath(indexPath.row)
      if pathManager._selected == indexPath.row {
        cell.backgroundColor = UIColor.yellowColor()
      }
      cell.textLabel?.text = currentPath?.description
    }
    
    //        let current_path = self.pathManager?.selectPathAtIndex(indexPath.row)
    //        cell.textLabel!.text = current_path!.name()
    return cell
  }
  
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    var selectedPath = pathManager?.selectPathAtIndex(indexPath.row)
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let pathManager = self.pathmanager {
      return pathManager.count()
    }
    return 0
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      if let pathManager = self.pathmanager {
        pathManager.removePath(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
      }
      //            pathManager?.deletePathAtIndex(indexPath.row)
      //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
    }
  }
}

// MARK: UUTableViewDataSource
extension PathManagerViewController: UITableViewDataSource{

}