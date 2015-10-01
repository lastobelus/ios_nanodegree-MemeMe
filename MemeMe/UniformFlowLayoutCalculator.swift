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

struct UniformFlowLayoutCalculator {
  var desiredSizeInPortrait:CGSize
  var desiredSizeInLandscape:CGSize
  var desiredSpacing:CGFloat
  func calculateDimension(desired:CGFloat, inSpace:CGFloat) -> CGFloat {
    let num = round((inSpace + desiredSpacing) / (desired + desiredSpacing))
    let dimension = (inSpace - ((num - 1) * desiredSpacing)) / num
    return dimension
  }

  func sizeForSize(available: CGSize) -> CGSize {
    let desiredSize = (available.width < available.height) ? desiredSizeInPortrait : desiredSizeInLandscape
    let width = calculateDimension(desiredSize.width, inSpace: available.width)
    let height = width / desiredSize.aspect()
    return CGSizeMake(width, height)
  }
}
