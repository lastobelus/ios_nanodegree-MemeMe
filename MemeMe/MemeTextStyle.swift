//
//  MemeStyle.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

struct MemeTextStyle {
  let strokeColor = UIColor.blackColor()
  let fontName = "HelveticaNeue-CondensedBlack"
  let color =  UIColor.whiteColor()
  let strokeSize: CGFloat
  let fontSize: CGFloat

  var attributes: [String: AnyObject] {
    return [
      NSStrokeColorAttributeName : UIColor.blackColor(),
      NSForegroundColorAttributeName : UIColor.whiteColor(),
      NSFontAttributeName : UIFont(name: fontName, size: fontSize)!,
      NSStrokeWidthAttributeName : -strokeSize
    ]
  }

  init(fontSize: CGFloat, strokeSize: CGFloat ) {
    self.fontSize = fontSize
    self.strokeSize = strokeSize
  }

}
