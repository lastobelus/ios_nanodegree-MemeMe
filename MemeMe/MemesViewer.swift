//
//  MemesViewer.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

protocol MemesViewer {
  var memesList: [Meme] { get }
  func populateCell(cell:MemesViewerCell, withMeme meme:Meme)
  func editIfEmpty()
  func indexOfSendingCell(sender:AnyObject?) -> Int?
  func prepareForShowDetailSegue(segue: UIStoryboardSegue, sender: AnyObject?) -> Bool
}

extension MemesViewer {
  var memesList: [Meme] {
    let store = MemeStore.sharedStore
    return store.savedMemes
  }
  
  func populateCell(cell:MemesViewerCell, withMeme meme:Meme) {
    let attributes = MemeTextStyle(fontSize: cell.memeTextFontSize, strokeSize: cell.memeTextStrokeSize).attributes
    cell.originalImage?.image = meme.image
    cell.topText?.attributedText = NSMutableAttributedString(string: meme.topText, attributes: attributes)
    cell.expandedTopText?.text = meme.topText
    cell.bottomText?.attributedText = NSMutableAttributedString(string: meme.bottomText, attributes: attributes)
    cell.expandedBottomText?.text = meme.bottomText
  }
}

struct MemeViewerProperties {
  static var editSegueIdentifier = "PresentMemeEditor"
  static var showDetailSegueIdentifier = "showMemeDetailSegue"
}

// common implementation for TableView and GridView
extension MemesViewer where Self : UIViewController {

  //  if the sent memes list is empty, automatically segue to the meme editor
  func editIfEmpty() {
    if memesList.isEmpty {
      performSegueWithIdentifier(MemeViewerProperties.editSegueIdentifier, sender: self)
    }
  }

//  if a segue is the "show detail" segue, set the meme of the sending cell on the destination controller
  func prepareForShowDetailSegue(segue: UIStoryboardSegue, sender: AnyObject?) -> Bool {
    guard segue.identifier == MemeViewerProperties.showDetailSegueIdentifier else {
      return false
    }

    guard let index = indexOfSendingCell(sender) else {
      return false
    }

    let destination = segue.destinationViewController as! MemeDetailViewController
    destination.meme = memesList[index]
    return true
  }
}

// common implementation for TableViewCell and GridViewCell
@objc protocol MemesViewerCell {
  var originalImage: UIImageView! { get }
  var topText: UILabel! { get }
  var bottomText: UILabel! { get }
  var memeTextFontSize:CGFloat { get }
  var memeTextStrokeSize:CGFloat { get }
  optional var expandedTopText: UILabel! { get }
  optional var expandedBottomText: UILabel! { get }
}
