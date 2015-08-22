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
      imageView.alpha = 0
      imageView.image = image
      imageView.contentMode = .ScaleAspectFit
      UIView.animateWithDuration(1,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseOut,
        animations: {
          self.imageView.alpha = 1.0
        },
        completion: nil
      )
    }
    animateLayout()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}