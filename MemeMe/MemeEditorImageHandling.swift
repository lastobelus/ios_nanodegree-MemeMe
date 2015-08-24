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
      UIView.animateWithDuration(0.5,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseOut,
        animations: {
          self.imageView.alpha = 1
        },
        completion: { finished in
          println("animation complete")
        }
      )
    }
    self.animateLayout()
    manageButtonState()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func removeImage() {
    // unlike fading in the image, fading it out works as expected
    UIView.animateWithDuration(0.5,
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
  
  func save() {
    //Create the meme
    let memedImage = generateMemedImage()
    var meme = Meme(
      topText: topTextField.text!,
      bottomText: bottomTextField.text!,
      image: imageView.image!,
      memedImage: memedImage
    )
  }
  
   func generateMemedImage() -> UIImage {
    
    // TODO: Hide toolbar and navbar
    //    hmmm. Why not just render imageView?
    
    // Render view to an image
    UIGraphicsBeginImageContext(imageView.frame.size)
    self.view.drawViewHierarchyInRect(imageView.frame,
      afterScreenUpdates: true)
    let memedImage : UIImage =
      UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    
    // TODO:  Show toolbar and navbar
    
    return memedImage
  }
}