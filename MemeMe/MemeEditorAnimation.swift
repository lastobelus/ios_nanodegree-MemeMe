//
//  MemeEditorAnimation.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

/**
Swift does not allow adding stored properties via extension. This extension
to NSLayoutConstraint uses the objc associatedObject dictionary to keep
track of constraints' orginal values.
*/
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
          objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
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


/**
MARK:- Animation of the editor view during editing.
*/
extension MemeEditorViewController {

  /**
  Organizes the size of the Meme image to show the text label being edited just above
  the keyboard, and keeps the text labels constained to the frame of the actual image.
  Everything is positioned by adjusting the constant on storyboard-set constraints,
  attached to outlets.
  TODO: switch to using storyboard ids for constraints instead of outlets
  */
  override func updateViewConstraints() {
    super.updateViewConstraints()
    // ensure we are calculating from a "settled" state
    self.view.layoutIfNeeded()

    // first calculate how much space the image would have before any interface
    // adjustments
    let availableWidth = imageView.bounds.width
    
    // topToolbarTopConstraint.delta is the additive inverse. We are deleting
    // it here, and will add it back if topToolbarShouldHide is true. Similarly
    // for bottomToolbar
    var availableHeight = imageView.bounds.height +
      imageViewBottomConstraint.delta() + imageViewTopConstraint.delta() +
      topToolbarTopConstraint.delta() + bottomToolbarBottomConstraint.delta()

    
    if topToolbarShouldHide {
      topToolbarTopConstraint.shift( -topToolbarHeightDefault)
      topToolbar.alpha = 0.0
      availableHeight -= topToolbarTopConstraint.delta()
    } else {
      topToolbar.alpha = 1.0
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
        availableHeight -= bottomShift
        imageViewBottomConstraint.shift(bottomShift)
        if Preferences.instance.expandImageTopPastStatusBarWhenTyping {
          
          let topShift = currentKeyboardHeight / 3.0
          availableHeight += topShift
          imageViewTopConstraint.shift( -topShift)
        } else {
          imageViewTopConstraint.reset()
        }
      default: ()
      }
    }

    let (letterBoxWidth, letterBoxHeight) = letterBoxForSize(CGSizeMake(availableWidth, availableHeight))

    adjustTextFieldWidths(letterBoxWidth)
    adjustTextFieldPositions(letterBoxHeight)
  
  }

  /**
  Calculates the scale & orientation of image when scaled to fit, and then
  calculates how much we need to adjust the textfield widths & positions.
  */
  func letterBoxForSize(size:CGSize) -> (CGFloat, CGFloat) {
    var letterBoxWidth = CGFloat(0)
    var letterBoxHeight = CGFloat(0)

    
    if let image = imageView.image {
      let widthRatio = size.width/image.size.width
      let heightRatio = size.height/image.size.height

      var scale = (heightRatio > widthRatio) ? widthRatio : heightRatio

      if scale >= 1.0 {
        imageView.contentMode = .Center
      } else {
        imageView.contentMode = .ScaleAspectFit
      }
      scale = min(scale, 1.0)
      let neededHeight = image.size.height * scale
      let neededWidth = image.size.width * scale
      letterBoxHeight = max((size.height - neededHeight) / 2.0, 0)
      letterBoxWidth = max((size.width - neededWidth) / 2.0, 0)

    }
    return (letterBoxWidth, letterBoxHeight)
  }

  /**
  When device rotates, update constraints and animate them during the rotation
  */
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
      self.updateConstraintsAndLayoutImmediately()
      }, completion: nil
    )
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
  }
  
  // update constraints within an animation block
  func animateLayout() {
    UIView.animateWithDuration(animationDuration,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseOut,
      animations: {
        self.updateConstraintsAndLayoutImmediately()
      },
      completion: nil
    )
  }

  /// Called when no animation is needed, otherwise call `animateLayout`
  func updateConstraintsAndLayoutImmediately() {
    self.view.setNeedsUpdateConstraints()
    self.view.layoutIfNeeded()
  }

  /// Hide or show toolbars
  func showToolbars(state:Bool) {
    topToolbarShouldHide = !state
    bottomToolbarShouldHide = !state
    updateConstraintsAndLayoutImmediately()
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
