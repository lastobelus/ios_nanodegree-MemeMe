//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 02.10.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

  @IBOutlet weak var memeImage: UIImageView!

  var meme:Meme?

  override func viewDidLoad() {
    super.viewDidLoad()
    populateViewFromMeme()
  }

  override func viewDidAppear(animated: Bool) {
    print("detail viewDidAppear")
    print("  memeImage: \(memeImage)")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == MemeViewerProperties.editMemeSegueIdentifier {
      if let editor = segue.destinationViewController as? MemeEditorViewController {
        editor.meme = meme
      }
    }
  }

  @IBAction func longPress(sender: UILongPressGestureRecognizer) {
    print("DetailView long press")
  }

  @IBAction func didFinishEditing(segue: UIStoryboardSegue) {
    populateViewFromMeme()
  }


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

    self.presentViewController(alert, animated: true, completion: nil)
  }

  func performDeleteMeme(alertAction: UIAlertAction!) -> Void  {
    self.performSegueWithIdentifier(MemeViewerProperties.shouldDeleteMemeSegueIdentifier, sender: nil)
  }

  private func populateViewFromMeme() {
    memeImage?.image = meme?.memedImage
  }
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */

  deinit {
    print("MemeDetailViewController deinitialized")
  }
}
