//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class SentMemesTableViewController: UITableViewController, MemesViewer {

  var memeForDeletion:NSIndexPath?

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func viewDidAppear(animated: Bool) {
    tableView.reloadData()
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
      confirmDelete(indexPath)
    }
  }

  func confirmDelete(indexPath: NSIndexPath) {
    memeForDeletion = indexPath
    let alert = UIAlertController(title: "Delete Meme", message: "Are you sure you want to permanently delete this Meme?", preferredStyle: .ActionSheet)
    let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: performDeleteMeme)
    let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteMeme)

    alert.addAction(DeleteAction)
    alert.addAction(CancelAction)

    self.presentViewController(alert, animated: true, completion: nil)
  }

  func performDeleteMeme(alertAction: UIAlertAction!) -> Void  {
    if let indexPath = memeForDeletion {
      tableView.beginUpdates()
      MemeStore.sharedStore.deleteMeme(atIndex: indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      memeForDeletion = nil
      tableView.endUpdates()
    }
  }

  func cancelDeleteMeme(alertAction: UIAlertAction!) {
    memeForDeletion = nil
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
