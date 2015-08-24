//
//  MemeEditorAnimation.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

// Swift does not allow adding stored properties via extension, so we use 
// objc associatedObject dictionary to keep track of constraints' orginal values
extension NSLayoutConstraint {
  private struct AssociatedKeys {
    static var OriginalValue = "mfa_original_value"
  }
  
  var originalValue: CGFloat {
    get {
      if let originalValue = objc_getAssociatedObject(self, &AssociatedKeys.OriginalValue) as? CGFloat {
        return originalValue
      } else {
        objc_setAssociatedObject(
          self,
          &AssociatedKeys.OriginalValue,
          constant,
          UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        )
        return constant
      }
    }
  }
  
  func delta()->CGFloat {
    return constant - originalValue
  }
  
  func reset() {
    constant = originalValue
  }
  
  func shift(distance:CGFloat) {
    constant = originalValue + distance
  }
  
}


extension MemeEditorViewController {

  override func updateViewConstraints() {
    super.updateViewConstraints()
    // ensure we are calculating from a "settled" state
    self.view.layoutIfNeeded()

    // first calculate how much space the image would have before any interface
    // adjustments
    var availableWidth = imageView.bounds.width
    
    // topToolbarTopConstraint.delta is the additive inverse. We are deleting
    // it here, and will add it back if topToolbarShouldHide is true. Similarly
    // for bottomToolbar
    var availableHeight = imageView.bounds.height +
      imageViewBottomConstraint.delta() + imageViewTopConstraint.delta() +
      topToolbarTopConstraint.delta() + bottomToolbarBottomConstraint.delta()

    
    if topToolbarShouldHide {
      topToolbarTopConstraint.shift( -topToolbarHeightDefault)
      availableHeight -= topToolbarTopConstraint.delta()
    } else {
      topToolbarTopConstraint.reset()
    }

    if bottomToolbarShouldHide {
      bottomToolbarBottomConstraint.shift( -bottomToolbarHeightDefault)
      availableHeight -= bottomToolbarBottomConstraint.delta()
    } else {
      bottomToolbarBottomConstraint.reset()
    }
    
    // setup image view constraints based on whether a textfield is active
    // and height of keyboard if showing
    imageViewBottomConstraint.reset()
    imageViewTopConstraint.reset()
    if let activeTextField = activeTextField {
      switch activeTextField {
      case topTextField:
        let shift = currentKeyboardHeight / 2.0
        availableHeight -= (shift)
        imageViewBottomConstraint.shift(shift)
        imageViewTopConstraint.reset()
      case bottomTextField:
        let bottomShift = currentKeyboardHeight
        let topShift = currentKeyboardHeight / 3.0
        availableHeight -= bottomShift
        availableHeight += topShift
        imageViewBottomConstraint.shift(bottomShift)
        imageViewTopConstraint.shift( -topShift)
      default: ()
      }
    }

    let (letterBoxWidth, letterBoxHeight) = letterBoxForSize(CGSizeMake(availableWidth, availableHeight))

    adjustTextFieldWidths(letterBoxWidth)
    adjustTextFieldPositions(letterBoxHeight)
  
  }

  func letterBoxForSize(size:CGSize) -> (CGFloat, CGFloat) {
    // calculate scale & orientation of image when scaled to fit, and then
    // calculate how much we need to adjust the textfield widths & position
    var letterBoxWidth = CGFloat(0)
    var letterBoxHeight = CGFloat(0)
    if let image = imageView.image {
      let widthRatio = size.width/image.size.width
      let heightRatio = size.height/image.size.height
      if heightRatio > widthRatio {
        let neededHeight = image.size.height * widthRatio
        letterBoxHeight = (size.height - neededHeight) / 2.0
      } else {
        let neededWidth = image.size.width * heightRatio
        letterBoxWidth = (size.width - neededWidth) / 2.0
      }
    }
    return (letterBoxWidth, letterBoxHeight)
  }

  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
      self.view.setNeedsUpdateConstraints()
      self.view.layoutIfNeeded()
      }, completion: nil
    )
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
  }
  
  func animateLayout() {
    UIView.animateWithDuration(animationDuration,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseOut,
      animations: {
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
      },
      completion: nil
    )
  }

  func showToolbars(state:Bool) {
    topToolbarShouldHide = !state
    bottomToolbarShouldHide = !state
    self.view.setNeedsUpdateConstraints()
    self.view.layoutIfNeeded()
  }

  private func adjustTextFieldWidths(width:CGFloat) {
    topTextLeftConstraint.shift(width)
    topTextRightConstraint.shift(width)
    bottomTextLeftConstraint.shift(width)
    bottomTextRightConstraint.shift(width)
  }

  private func adjustTextFieldPositions(shift :CGFloat) {
    topTextTopConstraint.shift( -shift)
    bottomTextBottomConstraint.shift(shift)
  }
}
