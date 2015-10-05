//
//  UniformFlowLayoutCalculator.swift
//  MemeMe
//
//  Created by Michael Johnston on 01.10.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

extension CGSize {
  func aspect() -> CGFloat {
    return width / height
  }
}

/**
An item-size calculator for CollectionViews that are layed out as a uniform grid.
- Sizes items to fit an integer number of items in the current screen width that will result in a size closest to the desired size
- Always maintains the aspect ratio of the desired size
- Allows separate desired sizes for Landscape & Portrait sizes
- Supports scaling
*/
struct UniformFlowLayoutCalculator {
  /// The desired height
  var desiredSizeInPortrait:CGSize
  var desiredSizeInLandscape:CGSize
  var minimumWidth:CGFloat
  var desiredSpacing:CGFloat
  var scale:CGFloat = 1.0

  /**
  Scale the desired size. Attach this to a pinch gesture recognizer to implement live grid resizing:
  
      @IBAction func scaleGrid(sender: UIPinchGestureRecognizer) {
        layoutCalculator.setScale(sender.scale)
        layoutCalculator.configureFlowLayout(flowLayout!, forSize:view.frame.size)
      }
  - Parameter: scale How much to scale the desired width when recalculating item sizes
  */
  mutating func setScale(scale: CGFloat) {
    self.scale = scale
  }

  /**
  Given a desired width and spacing, calculate the integral number of items that will fit in a space
  and have a width as close as possible to the desired width
  
  - Parameters:
    - desired: the desired item width
    - inSpace: the available width
  
  - Returns: an item width that will result in an integral number of items across the inSpace width
  */
  func calculateDimension(desired:CGFloat, inSpace:CGFloat) -> CGFloat {
    let num = round((inSpace + desiredSpacing) / (desired + desiredSpacing))
    let dimension = (inSpace - ((num - 1) * desiredSpacing)) / num
    return dimension
  }

  /**
  Given a `CGSize` representing a visible view frame, returns an item size that will result in an integral 
  number of items across the frame, with the aspect ratio of the desired size. Uses the frame's aspect
  ratio to determine whether to use desiredSizeInPortrait or desiredSizeInLandscape for the item size.

  - Parameter available: a view frame size
  - Returns: a `CGSize` for items
  */
  func sizeForSize(available: CGSize) -> CGSize {
    let portrait = (available.width < available.height)
    let desiredSize = portrait ? desiredSizeInPortrait : desiredSizeInLandscape
    let desiredSizeClamped = max(minimumWidth, min(available.width, available.height, desiredSize.width * scale))
    let width = calculateDimension(desiredSizeClamped, inSpace: available.width)
    let height = width / desiredSize.aspect()
    return CGSizeMake(width, height)
  }

  /**
  Calculates an item size for the supplied view frame size and configures a UICollectionViewFlowLayout with it.

  - Parameters:
    - flowLayout: The collection view flow layout object to configure
    - forSize: the size of the view frame to configure it for
  */
  func configureFlowLayout(flowLayout: UICollectionViewFlowLayout, forSize size:CGSize) {
    flowLayout.minimumInteritemSpacing = desiredSpacing
    flowLayout.minimumLineSpacing = desiredSpacing
    flowLayout.itemSize = sizeForSize(size)
    flowLayout.invalidateLayout()
  }

}
