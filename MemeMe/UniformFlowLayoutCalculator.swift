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
  var minimumWidth:CGFloat
  var desiredSpacing:CGFloat
  var scale:CGFloat = 1.0

  func calculateDimension(desired:CGFloat, inSpace:CGFloat) -> CGFloat {
    let num = round((inSpace + desiredSpacing) / (desired + desiredSpacing))
    let dimension = (inSpace - ((num - 1) * desiredSpacing)) / num
    return dimension
  }

  func sizeForSize(available: CGSize) -> CGSize {
    let portrait = (available.width < available.height)
    let desiredSize = portrait ? desiredSizeInPortrait : desiredSizeInLandscape
    let desiredSizeClamped = max(minimumWidth, min(available.width, available.height, desiredSize.width * scale))
    let width = calculateDimension(desiredSizeClamped, inSpace: available.width)
    let height = width / desiredSize.aspect()
    return CGSizeMake(width, height)
  }

  mutating func setScale(scale: CGFloat) {
    self.scale = scale
  }
}
