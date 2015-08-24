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
    topToolbarHeightDefault = topToolbar.bounds.height
    bottomToolbarHeightDefault = bottomToolbar.bounds.height

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

}

