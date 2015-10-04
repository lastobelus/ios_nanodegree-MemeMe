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

  @IBAction func didFinishEditing(segue: UIStoryboardSegue) {
    populateViewFromMeme()
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

}
