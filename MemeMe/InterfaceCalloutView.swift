//
//  InterfaceCalloutView.swift
//  MemeMe
//
//  Created by Michael Johnston on 30.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

class InterfaceCalloutView: UIView {


  //  RADAR: chaining animations does not work properly if you use scale(0,0)
  let minScale = CGAffineTransformMakeScale(0.01, 0.01)
  let maxScale = CGAffineTransformMakeScale(1.0, 1.0)
  let startTranslate = CGAffineTransformMakeTranslation(50, 150)
  let endTranslate = CGAffineTransformMakeTranslation(0, 0)
  let comeInDuration:NSTimeInterval = 0.8
  let goOutDuration:NSTimeInterval = 0.4
  let showDuration:NSTimeInterval = 4


  func fire() {
    if hidden {
      transform = CGAffineTransformConcat(minScale, startTranslate)
      hidden = false
      UIView.animateWithDuration(comeInDuration, delay: 0.0, usingSpringWithDamping: 0.6,
        initialSpringVelocity: 0.5, options: [], animations: {
          self.transform = CGAffineTransformConcat(self.maxScale, self.endTranslate)
        }, completion: { finished in
          UIView.animateWithDuration(self.goOutDuration, delay: self.showDuration, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.transform = CGAffineTransformConcat(self.minScale, self.startTranslate)
            }, completion: { finished in
              self.hidden = true
            }
          )
        }
      )
    }
  }

  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    drawTriangle()
  }

  func drawTriangle() {
    let shapeLayer = CAShapeLayer()
    let path = UIBezierPath()
    let bounds = self.bounds;
    let radius:CGFloat = 10;
    let a = radius * sqrt(3.0) / 2;
    let b = radius / 2;
    path.moveToPoint(CGPointMake(0, -radius))
    path.addLineToPoint(CGPointMake(a, b))
    path.addLineToPoint(CGPointMake(-a, b))

    path.closePath()
    path.applyTransform(CGAffineTransformMakeTranslation(CGRectGetMinX(bounds)+radius+2, CGRectGetMinY(bounds) - radius/2 + 1))
    shapeLayer.path = path.CGPath;

    shapeLayer.fillColor = backgroundColor?.CGColor

    layer.addSublayer(shapeLayer)
  }
  


}
