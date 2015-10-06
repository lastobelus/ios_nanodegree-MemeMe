//
//  ViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 20.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit
import TOCropViewController

/**
A ViewController that provides an interface for creating and editing a Meme.
- animates its contents to accomodate the device keyboard when editing texts
- provides an image picker
- provides an interface for cropping a chosen image
- provides an activity controller for sharing a Meme
- handles saving an existing meme via unwind segue
*/
class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

  //  MARK:- Meme views
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  var textFieldDefaultText: [UITextField:String] = [:]
  @IBOutlet weak var imageView: UIImageView!

  //MARK:- Toolbars
  @IBOutlet weak var topToolbar: UIToolbar!
  var topToolbarHeightDefault: CGFloat!
  var topToolbarShouldHide = false
  
  @IBOutlet weak var bottomToolbar: UIToolbar!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  var bottomToolbarHeightDefault: CGFloat!
  var bottomToolbarShouldHide = false
  
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var actionButton: UIBarButtonItem!
  @IBOutlet var saveButton: UIBarButtonItem!
  var indexOfSaveButton:Int = 0

//  MARK:- Constraints
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
  
  @IBOutlet weak var shareMemeIndicatorView: InterfaceCalloutView!

  ///  MARK:- State Properties
  var meme: Meme?
  
  var currentKeyboardHeight:CGFloat = 0.0
  var pickingImage = false
  var instructionsShown = false
  var activeTextField: UITextField?
  var isFirstMeme: Bool {
    get {
      return MemeStore.sharedStore.isFirstMeme()
    }
  }

  //MARK:- Constants
  let memeTextAttributes = MemeTextStyle(fontSize: 40, strokeSize: 5.0).attributes
  let imagePicker = UIImagePickerController()
  let animationDuration:NSTimeInterval = 0.4


  //MARK:- View Management
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
    configureTextField(topTextField)
    configureTextField(bottomTextField)

    textFieldDefaultText[topTextField] = topTextField.text
    textFieldDefaultText[bottomTextField] = bottomTextField.text

    if let meme = self.meme {
      populateViewFromMeme(meme)
    }

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

  //MARK:- Actions

  /// Action to provide a Meme image by taking a picture with the camera
  @IBAction func pickPhotoFromCamera(sender: UIBarButtonItem) {
    pickPhotoFromSource(.Camera)
  }
  
  /// Action to pick a photo from the photo album
  @IBAction func pickPhotoFromAlbum(sender: UIBarButtonItem) {
    pickPhotoFromSource(.PhotoLibrary)
  }
  
  /// Action to cancel the creation of a Meme and return to the Sent Memes list or Meme Detail
  @IBAction func cancel(sender: UIBarButtonItem) {
    removeImage()
    topTextField.text = textFieldDefaultText[topTextField]
    bottomTextField.text = textFieldDefaultText[bottomTextField]
    manageButtonState()
    animateLayout()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  /**
  Presents an activity controller. Upon completion, the exit segue `didFinishEditingMemeSegue`
  will be performed if an existing meme was being edited, to give other views an opportunity to
  refresh.
  */
  @IBAction func shareMeme(sender: UIBarButtonItem) {
    let memedImage = generateMemedImage()

    let activityController = UIActivityViewController(
      activityItems: [memedImage],
      applicationActivities: nil)
    
    activityController.completionWithItemsHandler = { activity, success, items, error in
      self.save(memedImage)
      // if we are editing an existing meme, use exit segue to ensure the detail view updates
      if success {
        if self.meme != nil {
          self.performSegueWithIdentifier(MemeViewerProperties.didFinishEditingMemeSegueIdentifier, sender: self)
        } else {
          self.dismissViewControllerAnimated(true, completion: nil)
        }
      }
    }
    
    presentViewController(activityController,
      animated: true, completion: nil)
  }

  /** 
  Action to save a meme that is only available when the meme being edited was already persisted/sent
  */
  @IBAction func saveMeme(sender: UIBarButtonItem) {
    let memedImage = generateMemedImage()
    save(memedImage)
    performSegueWithIdentifier(MemeViewerProperties.didFinishEditingMemeSegueIdentifier, sender: self)
  }

  //MARK:- State Management

  /// Update button states when there have been no changes persisted to the model
  func manageButtonState() {
    manageButtonState(withChanges: false)
  }

  /**
  Update button states, based on:
  - whether this is the first meme
  - whether an image has been set
  - whether at least one of top or bottom text has been set
  - whether changes have been made to a previously persisted meme
  
  - Parameter withChanges: boolean indicating whether there have been changes persisted to the model
  */
  func manageButtonState(withChanges changes:Bool) {
    actionButton.enabled = (imageView.image != nil) &&
      (!textIsDefault(topTextField) || !textIsDefault(bottomTextField))
    if isFirstMeme {
      cancelButton?.enabled = (imageView?.image != nil)
    } else {
      cancelButton?.enabled = true
    }
    if changes && (meme != nil) {
      showSaveButton()
    } else {
      hideSaveButton()
    }
  }

  /// Hides the save button in the top toolbar if it is currently showing
  func hideSaveButton() {
    if var toolbarButtons = topToolbar?.items {
      if let index = toolbarButtons.indexOf(saveButton!) {
        indexOfSaveButton = index
        toolbarButtons.removeAtIndex(indexOfSaveButton)
        topToolbar?.items = toolbarButtons
      }
    }
  }
  
  /// Shows the save button in the top toolbar if it is currently hidden
  func showSaveButton() {
    if var toolbarButtons = topToolbar?.items {
      if !toolbarButtons.contains(saveButton!) {
        toolbarButtons.insert(saveButton!, atIndex: indexOfSaveButton)
        topToolbar?.setItems(toolbarButtons, animated: true)
      }
    }
  }

  func textIsDefault(textField: UITextField) -> Bool {
    return textField.text == textFieldDefaultText[textField]
  }

  //MARK:- Onboarding

  /// Shows an alert explaining how to get started with the Meme Editor
  func showInstructions() {
    let alertController = UIAlertController(title: "Let's get started…", message: "Take a picture, or choose one from your Photos. Then click on the top & bottom labels to edit your meme.", preferredStyle: .Alert)

    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(OKAction)

    self.presentViewController(alertController, animated: true) { (action) in
      self.instructionsShown = true
    }
  }

  /// Shows the Share Meme callout view after a delay
  func showShareMemeIndicatorDelayed() {
    let delay = 1.5 * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    dispatch_after(time, dispatch_get_main_queue()) {
      self.showShareMemeIndicator()
    }
  }

  /// Shows the Share Meme callout view
  func showShareMemeIndicator() {
    if isFirstMeme {
      if imageView?.image != nil {
        if activeTextField == nil {
          if (!textIsDefault(topTextField) || !textIsDefault(bottomTextField)) {
            shareMemeIndicatorView.fire()
          }
        }
      }
    }
  }

  //MARK:- Setup
  private func populateViewFromMeme(meme:Meme) {
    imageView?.image = meme.image
    topTextField?.text = meme.topText
    bottomTextField?.text = meme.bottomText
  }

  private func configureTextField(textField:UITextField) {
    textField.defaultTextAttributes = memeTextAttributes
    textField.textAlignment = .Center
  }


}

