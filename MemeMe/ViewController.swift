//
//  ViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 20.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  enum ImageOrientation {
    case Portrait, Landscape
    func description() -> String {
      switch self {
      case Portrait:
        return "Portrait"
      case .Landscape:
        return "Landscape"
      }
    }
  }

  
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var innerView: UIView!
  @IBOutlet weak var innerViewBottomConstraint: NSLayoutConstraint!

  let imagePicker = UIImagePickerController()

  let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -5.0
  ]
  
  var keyboardShowing: Bool = false
  var originalInnerViewBottomConstraint: CGFloat!
  var textFieldOffset: CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

    configureTextField(topTextField)
    configureTextField(bottomTextField)
    textFieldOffset = topTextField.frame.height
    
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewWillAppear(animated)
    subscribeToKeyboardNotifications()
    println("layoutTextFields in viewWillAppear")
    print("imageView.bounds: "); debugPrintln(self.imageView.bounds)
    self.originalInnerViewBottomConstraint = innerViewBottomConstraint.constant
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardNotifications()
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    println("\n----> viewWillTransitionToSize")
    print("size:             "); debugPrintln(size)
    print("imageView.bounds: "); debugPrintln(imageView.bounds)
    coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
      println("layoutTextFields in animateAlongsideTransition")
      print("imageView.bounds: "); debugPrintln(self.imageView.bounds)
      self.layoutTextFields()
      
      }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
        println("rotation completed")
    })
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
  }
  
  override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer) {
    println("\n----> preferredContentSizeDidChangeForChildContentContainer")
    debugPrintln(container)
    super.preferredContentSizeDidChangeForChildContentContainer(container)
    println("        after super preferredContentSizeDidChangeForChildContentContainer")    
  }
  
  @IBAction func pickPhotoFromCamera(sender: UIBarButtonItem) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .Camera
    imagePicker.cameraCaptureMode = .Photo

    presentViewController(imagePicker, animated: true, completion: nil)
  }

  @IBAction func pickPhotoFromAlbum(sender: UIBarButtonItem) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .PhotoLibrary

    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = image
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func configureTextField(textField:UITextField) {
    textField.defaultTextAttributes = memeTextAttributes
    textField.textAlignment = .Center
  }
  
  func keyboardWillShow(notification: NSNotification) {
    println("\n----> keyboardWillShow")
    let keyboardHeight = getKeyboardHeight(notification)
    var newConstraint: CGFloat
    
    if let image = imageView.image {
      let scale: CGFloat
      let orientation: ImageOrientation
      (scale, orientation) = imageScaleAndOrientation(image, withinView: imageView)
      if orientation == .Landscape {
        let availableSpace = (imageView.frame.height - (image.size.height * scale)) / 2.0
        println("     availableSpace: \(availableSpace)    (\(imageView.frame.height) - \(image.size.height) * \(scale)) / 2.0")
        newConstraint = originalInnerViewBottomConstraint! + max(keyboardHeight - availableSpace, 0)
      } else {
        newConstraint = originalInnerViewBottomConstraint! + keyboardHeight
      }
    } else {
      newConstraint = originalInnerViewBottomConstraint! + keyboardHeight
    }

    if !keyboardShowing {
      UIView.animateWithDuration(1, animations:
        {
          self.innerViewBottomConstraint.constant = newConstraint
          self.view.layoutIfNeeded()
        },
        completion: { finished in
          print("after animating show constraint: innerView: "); debugPrintln(self.innerView.frame)
          print("                                 imageView: "); debugPrintln(self.imageView.frame)
        }
      )
      println("    set innerViewBottomConstraint.constant to \(newConstraint)")
    }

    self.keyboardShowing = true
    
  }
  
  func keyboardWillHide(notification: NSNotification) {
    println("\n----> keyboardWillHide")
    if innerViewBottomConstraint.constant != originalInnerViewBottomConstraint! {
      UIView.animateWithDuration(1, animations:
        {
          self.innerViewBottomConstraint.constant = self.originalInnerViewBottomConstraint!
          self.keyboardShowing = false
          self.view.layoutIfNeeded()
        },
        completion: { finished in
          print("after animating hide constraint: innerView: "); debugPrintln(self.innerView.frame)
          print("                                 imageView: "); debugPrintln(self.imageView.frame)
        }
      )
      
      println("    set innerViewBottomConstraint.constant to \(originalInnerViewBottomConstraint!)")
    }
  }

  func subscribeToKeyboardNotifications() {
    println("---->subscribeToKeyboardNotifications")
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "keyboardWillShow:",
      name: UIKeyboardWillShowNotification,
      object: nil
    )
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "keyboardWillHide:",
      name: UIKeyboardWillHideNotification,
      object: nil
    )
  }
  
  func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  
  private func imageScaleAndOrientation(image: UIImage, withinView: UIImageView) -> (CGFloat, ImageOrientation) {
    println("-----> imageScaleAndOrientation")
    let imageSize = image.size
    let imageWidth = image.size.width
    let imageHeight = image.size.height
    let widthRatio = withinView.bounds.size.width/imageWidth
    let heightRatio = withinView.bounds.size.height/imageHeight
    print("imageSize: "); debugPrintln(imageSize)
    print("withinView: "); debugPrintln(withinView)
    print("imageHeight: "); debugPrintln(imageHeight)
    print("imageWidth: "); debugPrintln(imageWidth)
    
    if heightRatio > widthRatio {
      return (widthRatio, .Landscape)
    } else {
      return (heightRatio, .Portrait)
    }
  }
  
  private func layoutTextFields() {
    println("\n----> layoutTextFields")
    let scale: CGFloat
    let width: CGFloat
    let height: CGFloat
    let orientation: ImageOrientation
    let toolbarHeight:CGFloat = (keyboardShowing ? 0 : toolbar.frame.height)
    if let image = imageView.image {
      width = image.size.width
      height = image.size.height
      (scale, orientation) = imageScaleAndOrientation(image, withinView: imageView)
    } else {
      scale = 1.0
      width = imageView.bounds.width
      height = imageView.bounds.height
      orientation = .Portrait
    }

    println("orientation:     \(orientation.description())")
    print("scale:           "); debugPrintln(scale)
    print("width:           "); debugPrintln(width)
    print("height:          "); debugPrintln(height)
    print("textFieldOffset: "); debugPrintln(textFieldOffset)
    print("toolbar.height:  "); debugPrintln(toolbarHeight)
    
    switch orientation {
    case .Portrait:
      println("setting widths to \(scale * width)")
      topTextField.frame.size.width = scale * width
      let topCenter = CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetMinY(imageView.bounds) + textFieldOffset)
      print("setting top center to "); debugPrintln(topCenter)
      topTextField.center = topCenter;
      
      bottomTextField.frame.size.width = scale * width
      let bottomCenter = CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetMaxY(imageView.bounds) - textFieldOffset - toolbarHeight)
      print("setting bottom center to "); debugPrintln(bottomCenter)
      bottomTextField.center = bottomCenter
      
    case .Landscape:
      println("setting widths to \(width)")
      let halfHeight = height*scale/2.0
      
      topTextField.frame.size.width = width
      let topCenter = CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetMidY(imageView.bounds) - halfHeight + textFieldOffset);
      print("setting top center to "); debugPrintln(topCenter)
      topTextField.center = topCenter;
      
      bottomTextField.frame.size.width = width
      let bottomCenter = CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetMidY(imageView.bounds) + halfHeight - textFieldOffset);
      print("setting bottom center to "); debugPrintln(bottomCenter)
      bottomTextField.center = bottomCenter
    }
  }
  
  
  override func viewWillLayoutSubviews() {
    println("----> viewWillLayoutSubViews")
    print("     innerView.frame:");debugPrintln(innerView.frame)
    print("     imageView.frame:");debugPrintln(imageView.frame)
    super.viewWillLayoutSubviews()
    print("     now innerView.frame.orgin:");debugPrintln(innerView.frame)
    print("     imageView.frame:");debugPrintln(imageView.frame)
    println("     .viewWillLayoutSubViews")
  }
  
  override func viewDidLayoutSubviews() {
    println("----> viewDidLayoutSubviews")
    print("     innerView.frame.orgin:");debugPrintln(innerView.frame)
    super.viewDidLayoutSubviews()
    print("     now innerView.frame.orgin:");debugPrintln(innerView.frame)
    print("     imageView.frame:");debugPrintln(imageView.frame)
    self.layoutTextFields()
    println("     .viewDidLayoutSubviews")
  }
  
  override func updateViewConstraints() {
    println("----> updateViewConstraints")
    print("     innerView.frame.orgin:");debugPrintln(innerView.frame)
    super.updateViewConstraints()
    print("     now innerView.frame.orgin:");debugPrintln(innerView.frame)
    print("     imageView.frame:");debugPrintln(imageView.frame)
    println("     .updateViewConstraints")
  }
  
}

