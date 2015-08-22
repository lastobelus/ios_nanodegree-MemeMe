//
//  ViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 20.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var toolbar: UIToolbar!

  @IBOutlet weak var topTextLeftConstraint: NSLayoutConstraint!
  var topTextLeftConstraintDefault: CGFloat!
  @IBOutlet weak var topTextRightConstraint: NSLayoutConstraint!
  var topTextRightConstraintDefault: CGFloat!
  @IBOutlet weak var topTextTopConstraint: NSLayoutConstraint!
  var topTextTopConstraintDefault: CGFloat!

  @IBOutlet weak var bottomTextLeftConstraint: NSLayoutConstraint!
  var bottomTextLeftConstraintDefault: CGFloat!
  @IBOutlet weak var bottomTextRightConstraint: NSLayoutConstraint!
  var bottomTextRightConstraintDefault: CGFloat!
  @IBOutlet weak var bottomTextBottomConstraint: NSLayoutConstraint!
  var bottomTextBottomConstraintDefault: CGFloat!
  
  @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
  var imageViewTopConstraintDefault: CGFloat!
  @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
  var imageViewBottomConstraintDefault: CGFloat!

  var currentKeyboardHeight: CGFloat = 0
  var activeTextField: UITextField?
  
  let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -5.0
  ]

  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    configureTextField(topTextField)
    configureTextField(bottomTextField)
    setupConstraintStartingValues()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardNotifications()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    subscribeToKeyboardNotifications()
  }

  override func updateViewConstraints() {
    super.updateViewConstraints()
    imageViewBottomConstraint.constant = imageViewBottomConstraintDefault
    imageViewTopConstraint.constant = imageViewTopConstraintDefault
    if let activeTextField = activeTextField {
      switch activeTextField {
      case topTextField:
        imageViewBottomConstraint.constant = imageViewBottomConstraintDefault + max((currentKeyboardHeight - toolbar.bounds.height)/3.0, 0)
        imageViewTopConstraint.constant = imageViewTopConstraintDefault
      case bottomTextField:
        imageViewBottomConstraint.constant = imageViewBottomConstraintDefault + max(currentKeyboardHeight - toolbar.bounds.height, 0)
        imageViewTopConstraint.constant = imageViewTopConstraintDefault - (currentKeyboardHeight / 3.0)
      default: ()
      }
    }
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
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func textFieldDidBeginEditing(textField: UITextField) {
    activeTextField = textField
    animateLayout()
  }
  
  func keyboardWillShow(notification: NSNotification) {
    currentKeyboardHeight = getKeyboardHeight(notification)
    animateLayout()
  }
  
  func keyboardWillHide(notification: NSNotification) {
    currentKeyboardHeight = 0
    animateLayout()
  }

  private func animateLayout() {
    UIView.animateWithDuration(0.5,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseOut,
      animations: {
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
      },
      completion: { finished in
        println("animateLayout completed");
        debugPrintln(self.imageView.bounds)
        debugPrintln(self.imageView.image?.size)
      }
    )
  }

  private func configureTextField(textField:UITextField) {
    textField.defaultTextAttributes = memeTextAttributes
    textField.textAlignment = .Center
  }

  private func subscribeToKeyboardNotifications() {
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
  
  private func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }

  private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }

  private func setupConstraintStartingValues() {
    topTextLeftConstraintDefault = topTextLeftConstraint.constant
    topTextRightConstraintDefault = topTextRightConstraint.constant
    topTextTopConstraintDefault = topTextTopConstraint.constant
    
    bottomTextLeftConstraintDefault = bottomTextLeftConstraint.constant
    bottomTextRightConstraintDefault = bottomTextRightConstraint.constant
    bottomTextBottomConstraintDefault = bottomTextBottomConstraint.constant
    
    imageViewTopConstraintDefault = imageViewTopConstraint.constant
    imageViewBottomConstraintDefault = imageViewBottomConstraint.constant
  }
}

