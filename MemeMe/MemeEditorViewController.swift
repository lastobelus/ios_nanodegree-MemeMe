//
//  ViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 20.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit
import TOCropViewController

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
  
  
  @IBOutlet weak var topToolbarTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomToolbarBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var actionButton: UIBarButtonItem!
  
  var currentKeyboardHeight:CGFloat = 0.0
  
  var activeTextField: UITextField?
  
  let memeTextAttributes = MemeTextStyle(fontSize: 40, strokeSize: 5.0).attributes
  
  let imagePicker = UIImagePickerController()
  
  let animationDuration:NSTimeInterval = 0.4

  var isFirstMeme: Bool {
    get {
      return MemeStore.sharedStore.isFirstMeme()
    }
  }

  var instructionsShown = false

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
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardNotifications()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    subscribeToKeyboardNotifications()
    if isFirstMeme && !instructionsShown {
      showInstructions()
    }
  }
  
  @IBAction func pickPhotoFromCamera(sender: UIBarButtonItem) {
    pickPhotoFromSource(.Camera)
  }
  
  @IBAction func pickPhotoFromAlbum(sender: UIBarButtonItem) {
    pickPhotoFromSource(.PhotoLibrary)
  }
  
  @IBAction func cancel(sender: UIBarButtonItem) {
    removeImage()
    topTextField.text = textFieldDefaultText[topTextField]
    bottomTextField.text = textFieldDefaultText[bottomTextField]
    manageButtonState()
    animateLayout()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func shareMeme(sender: UIBarButtonItem) {
    let memedImage = generateMemedImage()
    let activityController = UIActivityViewController(
      activityItems: [memedImage],
      applicationActivities: nil)
    
    activityController.completionWithItemsHandler = { activity, success, items, error in
      
      
      self.save(memedImage)
      
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    presentViewController(activityController,
      animated: true, completion: nil)
  }
  
  func manageButtonState() {
    actionButton.enabled = (imageView.image != nil) &&
      (!textIsDefault(topTextField) || !textIsDefault(bottomTextField))
    cancelButton?.enabled = !isFirstMeme || (imageView?.image != nil)

  }
  
  func textIsDefault(textField: UITextField) -> Bool {
    return textField.text == textFieldDefaultText[textField]
  }

  func showInstructions() {
    let alertController = UIAlertController(title: "Let's get started…", message: "Take a picture, or choose one from your Photos. Then click on the top & bottom labels to edit your meme.", preferredStyle: .Alert)

    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(OKAction)

    self.presentViewController(alertController, animated: true) { (action) in
      self.instructionsShown = true
    }
  }

  private func configureTextField(textField:UITextField) {
    textField.defaultTextAttributes = memeTextAttributes
    textField.textAlignment = .Center
  }
}

