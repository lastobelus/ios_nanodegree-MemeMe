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
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var topToolbar: UIToolbar!
  var topToolbarHeightDefault: CGFloat!
  var topToolbarShouldHide = false

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
  @IBOutlet weak var imageViewLeftConstraint: NSLayoutConstraint!
  var imageViewLeftConstraintDefault: CGFloat!
  @IBOutlet weak var imageViewRightConstraint: NSLayoutConstraint!
  var imageViewRightConstraintDefault: CGFloat!

  
  @IBOutlet weak var topToolbarTopConstraint: NSLayoutConstraint!
  var topToolbarTopConstraintDefault: CGFloat!
  
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
    topToolbar.hidden = false
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
  

  private func configureTextField(textField:UITextField) {
    textField.defaultTextAttributes = memeTextAttributes
    textField.textAlignment = .Center
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
    imageViewLeftConstraintDefault = imageViewLeftConstraint.constant
    imageViewRightConstraintDefault = imageViewRightConstraint.constant
    
    topToolbarTopConstraintDefault = topToolbarTopConstraint.constant
    topToolbarHeightDefault = topToolbar.bounds.height
  }
}

