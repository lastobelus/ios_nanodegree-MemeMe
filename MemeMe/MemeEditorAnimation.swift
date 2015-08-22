//
//  MemeEditorAnimation.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

extension MemeEditorViewController {
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    
    var letterBoxWidth = CGFloat(0)
    var letterBoxHeight = CGFloat(0)
    
    var availableWidth = imageView.bounds.width +
      imageViewLeftConstraint.constant - imageViewLeftConstraintDefault +
      imageViewRightConstraint.constant - imageViewRightConstraintDefault
    var availableHeight = imageView.bounds.height +
      imageViewBottomConstraint.constant - imageViewBottomConstraintDefault +
      imageViewTopConstraint.constant - imageViewTopConstraintDefault
    
    var neededHeight: CGFloat = availableHeight
    var neededWidth: CGFloat = availableWidth
    
    if let activeTextField = activeTextField {
      switch activeTextField {
      case topTextField:
        availableHeight -= (currentKeyboardHeight / 2.0 )
      case bottomTextField:
        availableHeight -= (currentKeyboardHeight - toolbar.bounds.height)
        availableHeight += ( currentKeyboardHeight / 3.0)
      default: ()
      }
    }
    
    
    if let image = imageView.image {
      let widthRatio = availableWidth/image.size.width
      let heightRatio = availableHeight/image.size.height
      if heightRatio > widthRatio {
        neededHeight = image.size.height * widthRatio
        letterBoxHeight = (availableHeight - neededHeight) / 2.0
      } else {
        neededWidth = image.size.width * heightRatio
        letterBoxWidth = (availableWidth - neededWidth) / 2.0
      }
    }
    
    topTextLeftConstraint.constant = topTextLeftConstraintDefault + letterBoxWidth
    topTextRightConstraint.constant = topTextRightConstraintDefault + letterBoxWidth
    topTextTopConstraint.constant = topTextTopConstraintDefault - letterBoxHeight
    
    bottomTextLeftConstraint.constant = bottomTextLeftConstraintDefault + letterBoxWidth
    bottomTextRightConstraint.constant = bottomTextRightConstraintDefault + letterBoxWidth
    bottomTextBottomConstraint.constant = bottomTextBottomConstraintDefault + letterBoxHeight
    
    if let activeTextField = activeTextField {
      switch activeTextField {
      case topTextField:
        imageViewBottomConstraint.constant = imageViewBottomConstraintDefault + (currentKeyboardHeight / 2.0)
        //        topTextTopConstraint.constant += (currentKeyboardHeight / 3.0)
        imageViewTopConstraint.constant = imageViewTopConstraintDefault
      case bottomTextField:
        imageViewBottomConstraint.constant = imageViewBottomConstraintDefault + currentKeyboardHeight - toolbar.bounds.height
        imageViewTopConstraint.constant = imageViewTopConstraintDefault - (currentKeyboardHeight / 3.0)
      default:
        imageViewBottomConstraint.constant = imageViewBottomConstraintDefault
        imageViewTopConstraint.constant = imageViewTopConstraintDefault
      }
    }
    
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
    UIView.animateWithDuration(0.5,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseOut,
      animations: {
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
      },
      completion: { finished in
        println("animateLayout completed");
      }
    )
  }

}
