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
    animateLayout(nil)
    manageButtonState()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func removeImage() {
    // unlike fading in the image, fading it out works as expected
    UIView.animateWithDuration(0.3,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseOut,
      animations: {
        self.imageView.alpha = 0.0
      },
      completion: { finished in
        self.imageView.image = nil
        self.imageView.alpha = 1.0
        self.animateLayout(nil)
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
    println("\n---> generateMemedImage ----")
    println("    before redrawing with hide toolbars & shouldShrinkImageView")
    print("    view.bounds:           "); debugPrintln(view.bounds)
    print("    view.bounds.size:      "); debugPrintln(view.bounds.size)
    print("    imageView.bounds:      "); debugPrintln(imageView.bounds)
    print("    imageView.bounds.size: "); debugPrintln(view.bounds.size)
    print("    imageView.frame:       "); debugPrintln(imageView.frame)
    print("    imageView.frame.origin:"); debugPrintln(imageView.frame.origin)
    print("    imageView.frame.size:  "); debugPrintln(imageView.frame.size)

    println()
    shouldShrinkImageView = true
    topToolbarShouldHide = true
    bottomToolbarShouldHide = true
    self.view.setNeedsUpdateConstraints()
    self.view.layoutIfNeeded()
    println("    after redrawing with hide toolbars & shouldShrinkImageView")
    print("    view.boundus:           "); debugPrintln(view.bounds)
    print("    view.bounds.size:      "); debugPrintln(view.bounds.size)
    println()
    print("    imageView.bounds:      "); debugPrintln(imageView.bounds)
    print("    imageView.bounds.size: "); debugPrintln(imageView.bounds.size)
    print("    imageView.frame:       "); debugPrintln(imageView.frame)
    print("    imageView.frame.origin:"); debugPrintln(imageView.frame.origin)
    print("    imageView.frame.size:  "); debugPrintln(imageView.frame.size)
    println()



    let (letterBoxWidth, letterBoxHeight) = letterBoxForSize(imageView.bounds.size)
    print("    letterBoxWidth: "); debugPrintln(letterBoxWidth)
    print("    letterBoxHeight: "); debugPrintln(letterBoxHeight)


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
    
    print("    imageSize: "); debugPrintln(imageSize)
    print("    imageOrigin: "); debugPrintln(imageOrigin)

    UIGraphicsBeginImageContext(imageSize)
    wholeImage.drawAtPoint(imageOrigin)
    let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();




    print("    memedImage.size: "); debugPrintln(memedImage.size)
    // TODO:  Show toolbar and navbar
    topToolbarShouldHide = false
    bottomToolbarShouldHide = false
    shouldShrinkImageView = false
    self.view.setNeedsUpdateConstraints()
    self.view.layoutIfNeeded()
    
    return memedImage
  }

  func generateMemedImageAsync(completion: ((UIImage)->Void)) {
    println("\n---> generateMemedImageAsync ----")
    println("    before redrawing with hide toolbars & shouldShrinkImageView")
    print("    view.bounds:           "); debugPrintln(view.bounds)
    print("    view.bounds.size:      "); debugPrintln(view.bounds.size)
    print("    imageView.bounds:      "); debugPrintln(imageView.bounds)
    print("    imageView.bounds.size: "); debugPrintln(view.bounds.size)
    print("    imageView.frame:       "); debugPrintln(imageView.frame)
    print("    imageView.frame.origin:"); debugPrintln(imageView.frame.origin)
    print("    imageView.frame.size:  "); debugPrintln(imageView.frame.size)

    println()

    shouldShrinkImageView = true
    topToolbarShouldHide = true
    bottomToolbarShouldHide = true


    animateLayout({ finished in
      println("    after redrawing with hide toolbars & shouldShrinkImageView")
      print("    view.boundus:           "); debugPrintln(self.view.bounds)
      print("    view.bounds.size:      "); debugPrintln(self.view.bounds.size)
      print("    imageView.bounds:      "); debugPrintln(self.imageView.bounds)
      print("    imageView.bounds.size: "); debugPrintln(self.imageView.bounds.size)
      print("    imageView.frame:       "); debugPrintln(self.imageView.frame)
      print("    imageView.frame.origin:"); debugPrintln(self.imageView.frame.origin)
      print("    imageView.frame.size:  "); debugPrintln(self.imageView.frame.size)

      println("drawing image")
      UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, true, 1.0)
      self.view.drawViewHierarchyInRect(self.imageView.frame,
        afterScreenUpdates: false)
      let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      print("    memedImage.size: "); debugPrintln(memedImage.size)
      // TODO:  Show toolbar and navbar
      self.topToolbarShouldHide = false
      self.bottomToolbarShouldHide = false
      self.shouldShrinkImageView = false
      self.view.setNeedsUpdateConstraints()
      self.view.layoutIfNeeded()
      completion(memedImage)
    })
  }

}