//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit



/**
Displays sent Memes in a grid. 
- Elements of the grid can be re-ordered by long-pressing
an item and moving it around
- the size of items in the grid can be changed via pinch
- selecting an item displays it in the Meme Detail view
- has an unwind segue action to provide deletion of selected item
*/
class SentMemesCollectionViewController: UICollectionViewController, MemesViewer {
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

  var movingRowIndexPath: NSIndexPath?
  var movingRowSnapshot: UIView?
  var canMemeMoveHorizontally = true
  var memesListView: UIView {
    get {
      return self.collectionView!
    }
  }


  var layoutCalculator = UniformFlowLayoutCalculator(
    desiredSizeInPortrait: CGSizeMake(120, 100),
    desiredSizeInLandscape: CGSizeMake(192, 120),
    minimumWidth: 60,
    desiredSpacing: 3.0,
    scale: 1.0
  )

  //MARK:- View Management
  override func viewDidLoad() {
    super.viewDidLoad()

    layoutCalculator.configureFlowLayout(flowLayout!, forSize:view.frame.size)
  }

  override func viewDidAppear(animated: Bool) {
    collectionView?.reloadData()
    editIfEmpty()
  }

  //MARK:- UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return memesList.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MemeViewerProperties.memeCellIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
    let meme = memesList[indexPath.row]
    
    populateCell(cell, withMeme: meme)
    
    return cell
  }
  
  //MARK:- UICollectionViewDelegate

  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

  //MARK:- Layout/Scaling
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    layoutCalculator.configureFlowLayout(flowLayout!, forSize: size)
  }

  @IBAction func scaleGrid(sender: UIPinchGestureRecognizer) {
    layoutCalculator.setScale(sender.scale)
    layoutCalculator.configureFlowLayout(flowLayout!, forSize:view.frame.size)
  }

  //MARK:- Reordering
  @IBAction func longPress(sender: UILongPressGestureRecognizer) {
    handleMemeReorderGesture(sender)
  }

  func indexPathOfMemeAtLocation(location: CGPoint) -> NSIndexPath? {
    return collectionView?.indexPathForItemAtPoint(location)
  }

  func cellViewForMemeAtIndexPath(indexPath: NSIndexPath) -> UIView? {
    return collectionView?.cellForItemAtIndexPath(indexPath)
  }

  func moveMemeAtIndexPath(from:NSIndexPath, toIndexPath to:NSIndexPath) {
    collectionView?.moveItemAtIndexPath(from, toIndexPath: to)
  }

  //MARK: - Deletion
  @IBAction func shouldDeleteMeme(segue: UIStoryboardSegue) {
    if let selection = collectionView?.indexPathsForSelectedItems()?.first {
      deleteMemeAtIndexPath(selection)
    }
  }

  func deleteMemeAtIndexPath(indexPath:NSIndexPath) {
    collectionView?.performBatchUpdates({
      MemeStore.sharedStore.deleteMeme(atIndex: indexPath.row)
      self.collectionView?.deleteItemsAtIndexPaths([indexPath])
      MemeStore.sharedStore.save()
    }, completion: nil)
  }
  
  
  //MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if prepareForShowDetailSegue(segue, sender: sender) {
      return
    }
  }
  
  func indexOfSendingCell(sender:AnyObject?) -> Int? {
    guard let cell = sender as? MemeCollectionViewCell else {
      return nil
    }
    guard let indexPath = collectionView!.indexPathForCell(cell) else {
      return nil
    }
    return indexPath.row
  }
}
