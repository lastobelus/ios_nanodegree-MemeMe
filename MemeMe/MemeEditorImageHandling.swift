//
//  MemeEditorImageHandling.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

extension MemeEditorViewController {
  func pickPhotoFromSource(source: UIImagePickerControllerSourceType, mode: UIImagePickerControllerCameraCaptureMode?) {
    if let mode = mode {
      imagePicker.cameraCaptureMode = mode
    }
    imagePicker.allowsEditing = false
    imagePicker.sourceType = source
    
    presentViewController(imagePicker, animated: true, completion: nil)
  }

  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = image
      imageView.contentMode = .ScaleAspectFit
      imageView.alpha = 0
      UIView.animateWithDuration(animationDuration,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseOut,
        animations: {
          self.imageView.alpha = 1
        },
        completion: nil
      )
    }
    animateLayout()
    manageButtonState()
    dismissViewControllerAnimated(true, completion: nil)
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
        self.imageView.alpha = 1.0
        self.animateLayout()
        self.manageButtonState()
      }
    )
  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func save(memedImage: UIImage) {
    //Create the meme
    var meme = Meme(
      topText: topTextField.text!,
      bottomText: bottomTextField.text!,
      image: imageView.image!,
      memedImage: memedImage
    )
  }

  func generateMemedImage() -> UIImage {

    showToolbars(false)

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

    return memedImage
  }

}