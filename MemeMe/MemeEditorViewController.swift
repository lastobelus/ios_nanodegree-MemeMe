//
//  ViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 20.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  var textFieldDefaultText: [UITextField:String] = [:]

  @IBOutlet weak var imageView: UIImageView!

  @IBOutlet weak var topToolbar: UIToolbar!
  var topToolbarHeightDefault: CGFloat!
  var topToolbarShouldHide = false

  @IBOutlet weak var bottomToolbar: UIToolbar!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  var bottomToolbarHeightDefault: CGFloat!
  var bottomToolbarShouldHide = false

  @IBOutlet weak var topTextLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var topTextRightConstraint: NSLayoutConstraint!
  @IBOutlet weak var topTextTopConstraint: NSLayoutConstraint!

  @IBOutlet weak var bottomTextLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomTextRightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomTextBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewRightConstraint: NSLayoutConstraint!

  
  @IBOutlet weak var topToolbarTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomToolbarBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var actionButton: UIBarButtonItem!

  var currentKeyboardHeight: CGFloat = 0
  var activeTextField: UITextField?
  var shouldShrinkImageView = false

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
    textFieldDefaultText[topTextField] = topTextField.text
    textFieldDefaultText[bottomTextField] = bottomTextField.text
    
    topToolbarHeightDefault = topToolbar.bounds.height
    bottomToolbarHeightDefault = bottomToolbar.bounds.height

    manageButtonState()
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

  @IBAction func pickPhotoFromCamera(sender: UIBarButtonItem) {
    pickPhotoFromSource(.Camera, mode: .Photo)
  }

  @IBAction func pickPhotoFromAlbum(sender: UIBarButtonItem) {
    pickPhotoFromSource(.PhotoLibrary, mode: nil)
  }
  
  @IBAction func cancel(sender: UIBarButtonItem) {
    removeImage()
    topTextField.text = textFieldDefaultText[topTextField]
    bottomTextField.text = textFieldDefaultText[bottomTextField]
    manageButtonState()
    animateLayout(nil)
  }

  @IBAction func shareMeme(sender: UIBarButtonItem) {
//    generateMemedImageAsync({ memedImage in
//      let activityController = UIActivityViewController(
//        activityItems: [memedImage],
//        applicationActivities: nil)
//
//      self.presentViewController(activityController,
//        animated: true, completion: nil)
//    })
//
    let memedImage = generateMemedImage()
    let activityController = UIActivityViewController(
      activityItems: [memedImage],
      applicationActivities: nil)
    
    self.presentViewController(activityController,
      animated: true, completion: nil)
  }
  

  func manageButtonState() {
    actionButton.enabled = imageView.image != nil
    cancelButton.enabled = (imageView.image != nil) ||
      !textIsDefault(topTextField) ||
      !textIsDefault(bottomTextField)
  }
  
  func textIsDefault(textField: UITextField) -> Bool {
    return textField.text == textFieldDefaultText[textField]
  }
  
  private func configureTextField(textField:UITextField) {
    textField.defaultTextAttributes = memeTextAttributes
    textField.textAlignment = .Center
  }

}

