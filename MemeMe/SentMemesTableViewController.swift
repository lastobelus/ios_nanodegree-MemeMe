//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class SentMemesTableViewController: UITableViewController, MemesViewer, MemeDeleter {

  var memeForDeletionIndexPath:NSIndexPath?
  var movingRowSnapshot: UIView?
  var movingRowIndexPath: NSIndexPath?

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func viewDidAppear(animated: Bool) {
    print("reloadData")
    tableView.reloadData()
    print("editIfEmpty")
    editIfEmpty()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memesList.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
    let meme = memesList[indexPath.row]

    populateCell(cell, withMeme: meme)

    return cell
  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */
  
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      memeForDeletionIndexPath = indexPath
      let alert = confirmDelete()
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }

  func performDeleteMeme(alertAction: UIAlertAction!) -> Void  {
    if let indexPath = memeForDeletionIndexPath {
      tableView.beginUpdates()
      MemeStore.sharedStore.deleteMeme(atIndex: indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      memeForDeletionIndexPath = nil
      tableView.endUpdates()
    }
  }

  func cancelDeleteMeme(alertAction: UIAlertAction!) {
    memeForDeletionIndexPath = nil
  }

  @IBAction func shouldDeleteMeme(segue: UIStoryboardSegue) {
    print("shouldDeleteMeme")
//    if let indexPath = tableView.indexPathForSelectedRow {
//      print("  selected index: \(indexPath.row)")
//      print("   topText: \(memesList[indexPath.row].topText)")
//    }
  }

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */
  
  // MARK: - Navigation
  @IBAction func longPress(sender: UILongPressGestureRecognizer) {
    let state = sender.state
    print("longpress. state: \(state.rawValue)")
    let location = sender.locationInView(tableView)



    switch (state) {
    case .Began:
      guard let indexPath = tableView.indexPathForRowAtPoint(location) else { return }
      movingRowIndexPath = indexPath
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        var snapshot = cellSnapshot(cell)
        movingRowSnapshot = snapshot
        var center = cell.center
        snapshot.center = center
        snapshot.alpha = 0.0
        tableView.addSubview(snapshot)
        UIView.animateWithDuration(0.25,
          animations: {
            center.y = location.y
            snapshot.center = center
            snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05)
            snapshot.alpha = 0.98
            cell.alpha = 0.0
          },
          completion: { finished in
            cell.hidden = true
          }
        )
      }

    case .Changed:
      print("changed")
      guard let indexPath = tableView.indexPathForRowAtPoint(location) else { return }
      if let snapshot = movingRowSnapshot {
        var center = snapshot.center
        center.y = location.y
        snapshot.center = center

        if indexPath != movingRowIndexPath {
          print("do the move")
          MemeStore.sharedStore.swapMemes(indexPath.row, second: movingRowIndexPath!.row)
          tableView.moveRowAtIndexPath(movingRowIndexPath!, toIndexPath:indexPath)
          movingRowIndexPath = indexPath
        }
      }
    default:
      print("default state")

      guard let snapshot = movingRowSnapshot, let indexPath = movingRowIndexPath else { return }

      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        print("unhide original cell")
        cell.hidden = false
        cell.alpha = 0.0
        UIView.animateWithDuration(0.25,
          animations: {
            snapshot.center = cell.center
            snapshot.transform = CGAffineTransformIdentity
            snapshot.alpha = 0.0
            cell.alpha = 1.0
        }, completion: { finished in
          MemeStore.sharedStore.save()
          self.movingRowIndexPath = nil
          snapshot.removeFromSuperview()
          self.movingRowSnapshot = nil
        })
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if prepareForShowDetailSegue(segue, sender: sender) {
      return
    }
  }

  func indexOfSendingCell(sender:AnyObject?) -> Int? {
    guard let cell = sender as? MemeTableViewCell else {
      return nil
    }
    guard let indexPath = tableView!.indexPathForCell(cell) else {
      return nil
    }
    return indexPath.row
  }

  private func cellSnapshot(inputView: UIView) -> UIView {
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
    inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    // Create an image view.
    var snapshot = UIImageView(image:image)
    snapshot.layer.masksToBounds = false
    snapshot.layer.cornerRadius = 0.0
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
    snapshot.layer.shadowRadius = 5.0
    snapshot.layer.shadowOpacity = 0.4

    return snapshot
  }

}
