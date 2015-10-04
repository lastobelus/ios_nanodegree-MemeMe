//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 02.10.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
  static let editSegueIdentifier = "editSelectedMemeSegue"

  @IBOutlet weak var memeImage: UIImageView!

  var meme:Meme?

  override func viewDidLoad() {
    super.viewDidLoad()
    memeImage?.image = meme?.memedImage
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
    if segue.identifier == MemeDetailViewController.editSegueIdentifier {
      NSLog("editSelectedMemeSegue")
    }
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
