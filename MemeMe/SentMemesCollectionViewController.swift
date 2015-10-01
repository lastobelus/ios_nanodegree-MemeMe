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

  let layoutCalculator = UniformFlowLayoutCalculator(
    desiredSizeInPortrait: CGSizeMake(192, 120),
    desiredSizeInLandscape: CGSizeMake(192*1.3, 120*1.3),
    desiredSpacing: 3.0
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


  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */
  
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
}
