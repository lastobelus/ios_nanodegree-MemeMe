//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 02.10.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

/**
  A View Controller for displaying the memed image of a sent meme.
  - Allows the user to delete a saved meme
  - Allows the user to edit a saved meme
*/
class MemeDetailViewController: UIViewController {

  @IBOutlet weak var memeImage: UIImageView!

  /// The meme being displayed
  var meme:Meme?

  //MARK:- View Management
  override func viewDidLoad() {
    super.viewDidLoad()
    populateViewFromMeme()
  }

  //MARK: - Actions
  /**
  Called when the user exits an editor view that was pushed to edit this meme to
  repopulate this view with any new properties saved to the meme.
  */
  @IBAction func didFinishEditing(segue: UIStoryboardSegue) {
    populateViewFromMeme()
  }

  /**
  Displays a modal alert to confirm deletion of this meme. If confirmed, the
  unwind segue `shouldDeleteMemeSegue` will be called
  */
  @IBAction func deleteAction(sender: UIBarButtonItem) {
    // RADAR: I attempted to extract this and duplicate code in SentMemesTableViewController
    // to a protocol+extension, but when I did I got exc_bad_access errors I was not
    // able to solve. By enabling NSZombieEnabled I discovered that when the alert controller
    // is created in a protocol extension, the presenting controller is deinitialized,
    // twice, with the second release causing the exc_bad_access.
    // See the git tag AttemptToAbstractConfirmDeleteToProtocol for a version that 
    // demonstrates this
    let alert = UIAlertController(title: "Delete Meme", message: "Are you sure you want to permanently delete this Meme?", preferredStyle: .ActionSheet)
    let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: performDeleteMeme)
    let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

    alert.addAction(DeleteAction)
    alert.addAction(CancelAction)

    presentViewController(alert, animated: true, completion: nil)
  }

  
  //MARK: - Navigation

  /**
  1. `editMemeSegue`: sets the meme on the destination
  */
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == MemeViewerProperties.editMemeSegueIdentifier {
      if let editor = segue.destinationViewController as? MemeEditorViewController {
        editor.meme = meme
      }
    }
  }

  /** 
  When user clicks Delete in the delete confirmation modal, this performs the delete
  by performing the unwind segue `shouldDeleteMemeSegue`.
  */
  func performDeleteMeme(alertAction: UIAlertAction!) -> Void  {
    performSegueWithIdentifier(MemeViewerProperties.shouldDeleteMemeSegueIdentifier, sender: nil)
  }

  /// sets up the subviews with properties of the Meme being displayed
  private func populateViewFromMeme() {
    memeImage?.image = meme?.memedImage
  }
}