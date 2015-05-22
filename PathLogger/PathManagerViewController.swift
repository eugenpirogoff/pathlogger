import UIKit

class PathManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let dateFormatter = NSDateFormatter()
    let pathstore = PathStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        pathstore.saveContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction() {
        if pathstore.recoding {
            pathstore.viewedPath = pathstore.recordingPath
        } else {
            pathstore.viewedPath = nil
        }
        dismissCurrentViewController()
    }
    
    func dismissCurrentViewController(){
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
        let cell = UITableViewCell()
        let path = pathstore.loadRecording(indexPath.row)
        if path.distanceInMeter > 1000 {
            let distance = NSString(format: "%.2f km", path.distanceInKilometer)
            cell.textLabel?.text = "\(dateFormatter.stringFromDate(path.startTimestamp)), \(distance)"
        } else {
            let distance = NSString(format: "%.2f m", path.distanceInMeter)
            cell.textLabel?.text = "\(dateFormatter.stringFromDate(path.startTimestamp)), \(distance)"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        pathstore.loadRecordingToView(indexPath.row)
        dismissCurrentViewController()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pathstore.recordingsCount
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            pathstore.removeRecordingAt(indexPath.row)
            pathstore.saveContext()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
}
