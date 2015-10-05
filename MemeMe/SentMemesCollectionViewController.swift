//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"


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

  override func viewDidLoad() {
    super.viewDidLoad()

    configureFlowLayoutForSize(view.frame.size)
  }

  override func viewDidAppear(animated: Bool) {
    collectionView?.reloadData()
    editIfEmpty()
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
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

  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return memesList.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
    let meme = memesList[indexPath.row]
    
    populateCell(cell, withMeme: meme)
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
  /*
  // Uncomment this method to specify if the specified item should be highlighted during tracking
  override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return true
  }
  */
  
  /*
  // Uncomment this method to specify if the specified item should be selected
  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return true
  }
  */
  
  /*
  // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
  override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return false
  }
  
  override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
  return false
  }
  
  override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
  
  }
  */

  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    configureFlowLayoutForSize(size)
    flowLayout?.invalidateLayout()
  }

  func configureFlowLayoutForSize(size:CGSize) {
    flowLayout?.minimumInteritemSpacing = layoutCalculator.desiredSpacing
    flowLayout?.minimumLineSpacing = layoutCalculator.desiredSpacing
    flowLayout?.itemSize = layoutCalculator.sizeForSize(size)
  }

  @IBAction func scaleGrid(sender: UIPinchGestureRecognizer) {
    print("scaleGrid: \(sender.scale)")
    layoutCalculator.setScale(sender.scale)
    configureFlowLayoutForSize(view.frame.size)
    flowLayout?.invalidateLayout()
  }

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
  

}
