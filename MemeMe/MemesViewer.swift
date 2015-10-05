//
//  MemesViewer.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

protocol MemesViewer : class {
  var memesList: [Meme] { get }
  var movingRowIndexPath: NSIndexPath? { get set }
  var movingRowSnapshot: UIView? { get set }
  var memesListView: UIView { get }
  var canMemeMoveHorizontally: Bool {get}

  func populateCell(cell:MemesViewerCell, withMeme meme:Meme)
  func editIfEmpty()
  func indexOfSendingCell(sender:AnyObject?) -> Int?
  func prepareForShowDetailSegue(segue: UIStoryboardSegue, sender: AnyObject?) -> Bool

  func handleMemeReorderGesture(sender: UILongPressGestureRecognizer)
  func indexPathOfMemeAtLocation(location: CGPoint) -> NSIndexPath?
  func cellViewForMemeAtIndexPath(indexPath: NSIndexPath) -> UIView?
  func moveMemeAtIndexPath(from:NSIndexPath, toIndexPath to:NSIndexPath)

}

protocol MemeViewer {
  var meme: Meme? {get set}
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
  static var editSegueIdentifier = "createMemeSegue"
  static var showDetailSegueIdentifier = "showMemeDetailSegue"
  static var editMemeSegueIdentifier = "editMemeSegue"
  static var didFinishEditingMemeSegueIdentifier = "didFinishEditingMemeSeque"
  static var shouldDeleteMemeSegueIdentifier = "shouldDeleteMemeSeque"
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

   func handleMemeReorderGesture(sender: UILongPressGestureRecognizer) {
    let state = sender.state
    print("longpress. state: \(state.rawValue)")
    let location = sender.locationInView(memesListView)



    switch (state) {
    case .Began:
      guard let indexPath = indexPathOfMemeAtLocation(location) else { return }
      movingRowIndexPath = indexPath
      if let cell = cellViewForMemeAtIndexPath(indexPath) {
        var snapshot = cellSnapshot(cell)
        movingRowSnapshot = snapshot
        var center = cell.center
        snapshot.center = center
        snapshot.alpha = 0.0
        memesListView.addSubview(snapshot)
        UIView.animateWithDuration(0.25,
          animations: {
            center.y = location.y
            if self.canMemeMoveHorizontally {
              center.x = location.x
            }
            snapshot.center = center
            snapshot.transform = CGAffineTransformMakeScale(1.08, 1.08)
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
      guard let indexPath = indexPathOfMemeAtLocation(location) else { return }
      if let snapshot = movingRowSnapshot {
        var center = snapshot.center
        center.y = location.y
        if canMemeMoveHorizontally {
          center.x = location.x
        }
        snapshot.center = center

        if indexPath != movingRowIndexPath {
          print("do the move")
          MemeStore.sharedStore.swapMemes(indexPath.row, second: movingRowIndexPath!.row)
          moveMemeAtIndexPath(movingRowIndexPath!, toIndexPath:indexPath)
          movingRowIndexPath = indexPath
        }
      }
    default:
      print("default state")

      guard let snapshot = movingRowSnapshot, let indexPath = movingRowIndexPath else { return }

      if let cell = cellViewForMemeAtIndexPath(indexPath) {
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
