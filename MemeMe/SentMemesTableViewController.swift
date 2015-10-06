//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

/**
Displays saved Memes in a table view.
- Elements of the grid can be re-ordered by long-pressing
an item and moving it around
- selecting an item displays it in the Meme Detail view
- items can be deleted by swiping left
- has an unwind segue action to provide deletion of selected item from the Meme Detail View
*/
class SentMemesTableViewController: UITableViewController, MemesViewer {
  var memeForDeletionIndexPath: NSIndexPath?

  var movingRowIndexPath: NSIndexPath?
  var movingRowSnapshot: UIView?
  var canMemeMoveHorizontally = false

  var memesListView: UIView {
    get {
      return self.tableView
    }
  }

  //MARK: View Management
  override func viewDidAppear(animated: Bool) {
    tableView.reloadData()
    editIfEmpty()
  }

  //MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memesList.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(MemeViewerProperties.memeCellIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
    let meme = memesList[indexPath.row]

    populateCell(cell, withMeme: meme)

    return cell
  }
  
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      memeForDeletionIndexPath = indexPath
      let alert = UIAlertController(title: "Delete Meme", message: "Are you sure you want to permanently delete this Meme?", preferredStyle: .ActionSheet)
      let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: performDeleteMeme)
      let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteMeme)

      alert.addAction(DeleteAction)
      alert.addAction(CancelAction)
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }

  //MARK:- Deletion
  
  @IBAction func shouldDeleteMeme(segue: UIStoryboardSegue) {
    if let indexPath = tableView.indexPathForSelectedRow {
      deleteMemeAtIndexPath(indexPath)
    }
  }
  func performDeleteMeme(alertAction: UIAlertAction!) -> Void  {
    if let indexPath = memeForDeletionIndexPath {
      deleteMemeAtIndexPath(indexPath)
    }
  }
  
  func deleteMemeAtIndexPath(indexPath:NSIndexPath) {
    tableView.beginUpdates()
    MemeStore.sharedStore.deleteMeme(atIndex: indexPath.row)
    MemeStore.sharedStore.save()
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    memeForDeletionIndexPath = nil
    tableView.endUpdates()
  }
  
  func cancelDeleteMeme(alertAction: UIAlertAction!) {
    memeForDeletionIndexPath = nil
  }
  
  //MARK:- Reordering
  @IBAction func longPress(sender: UILongPressGestureRecognizer) {
    handleMemeReorderGesture(sender)
  }

  func indexPathOfMemeAtLocation(location: CGPoint) -> NSIndexPath? {
    return tableView.indexPathForRowAtPoint(location)
  }

  func cellViewForMemeAtIndexPath(indexPath: NSIndexPath) -> UIView? {
    return tableView.cellForRowAtIndexPath(indexPath)
  }

  func moveMemeAtIndexPath(from:NSIndexPath, toIndexPath to:NSIndexPath) {
    tableView.moveRowAtIndexPath(from, toIndexPath:to)
  }


  //MARK: - Navigation
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
}
