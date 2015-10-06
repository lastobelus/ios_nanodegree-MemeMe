//
//  MemeEditorImageHandling.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit
import TOCropViewController

/**
Handle the choosing and editing of a Meme image
*/
extension MemeEditorViewController: TOCropViewControllerDelegate {

  /// Presents a UIImagePickerController
  func pickPhotoFromSource(source: UIImagePickerControllerSourceType) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = source
    if source == .Camera {
      imagePicker.cameraCaptureMode = .Photo
    }
    pickingImage = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }

  //MARK:- UIImagePickerControllerDelegate
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      updateConstraintsAndLayoutImmediately()
      dismissViewControllerAnimated(false,
        completion: {
          let cropController = TOCropViewController(image: image)
          cropController.delegate = self;
          self.presentViewController(cropController, animated:true, completion:nil);
      })
    } else {
      animateLayout()
      manageButtonState()
      dismissViewControllerAnimated(true, completion: nil)
      pickingImage = false
    }
  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK:- TOCropViewControllerDelegate
  func cropViewController(cropViewController: TOCropViewController!, didCropToImage image: UIImage!, withRect cropRect: CGRect, angle: Int) {
    imageView.image = image;
    imageView.contentMode = .ScaleAspectFit

    cropViewController.dismissAnimatedFromParentViewController(self,
      withCroppedImage:image,
      toFrame:CGRectZero,
      completion: {
        self.pickingImage = false
        self.animateLayout()
        self.manageButtonState(withChanges: true)
        self.showShareMemeIndicatorDelayed()
      }
    )
  }

  func removeImage() {
    // unlike fading in the image, fading it out works as expected
    UIView.animateWithDuration(animationDuration,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseOut,
      animations: {
        self.imageView.alpha = 0.0
      },
      completion: { finished in
        self.imageView.image = nil
        self.animateLayout()
        self.manageButtonState()
      }
    )
  }

  /**
  Generate a memed image by setting up the view to hide toolbars and then taking
  a snapshot, then restore the toolbars.
  */
  func generateMemedImage() -> UIImage {
    showToolbars(false)
    updateConstraintsAndLayoutImmediately()

    let (letterBoxWidth, letterBoxHeight) = letterBoxForSize(imageView.bounds.size)
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
    view.drawViewHierarchyInRect(view.frame,
      afterScreenUpdates: true)
    let wholeImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();

    let width = imageView.frame.size.width - (letterBoxWidth * 2)
    let height = imageView.frame.size.height - (letterBoxHeight * 2)
    let imageSize = CGSizeMake(width, height)
    let x = imageView.frame.origin.x + letterBoxWidth
    let y = imageView.frame.origin.y + letterBoxHeight
    let imageOrigin = CGPointMake(-x, -y)
    
    UIGraphicsBeginImageContext(imageSize)
    wholeImage.drawAtPoint(imageOrigin)
    let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    showToolbars(true)
    updateConstraintsAndLayoutImmediately()

    return memedImage
  }

}