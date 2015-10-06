//
//  MemeEditorTextHandling.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

/**
Handle the editing of the top and bottom Meme Labels
*/
extension MemeEditorViewController {
  //MARK:- UITextFieldDelegate
  func textFieldDidBeginEditing(textField: UITextField) {
    activeTextField = textField
    topToolbarShouldHide = true
    bottomToolbarShouldHide = true
    
    if textIsDefault(textField) {
      textField.text = ""
    }
    animateLayout()
  }

  func textFieldDidEndEditing(textField: UITextField) {
    activeTextField = nil
    if textField.text!.characters.count == 0 {
      textField.text = textFieldDefaultText[textField]
    }
    self.manageButtonState(withChanges: true)
    self.showShareMemeIndicatorDelayed()
  }

  /**
  When return is pressed in the top text field, edit the
  bottom one. When return is pressed in the bottom text field,
  restore the toolbars */
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if textField == topTextField {
      bottomTextField.becomeFirstResponder()
    } else {
      topToolbarShouldHide = false
      bottomToolbarShouldHide = false
      animateLayout()
    }
    return true;
  }
  
  //MARK:- Keyboard state notifications
  func subscribeToKeyboardNotifications() {
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

  func keyboardWillShow(notification: NSNotification) {
    currentKeyboardHeight = getKeyboardHeight(notification)
    animateLayout()
  }
  
  func keyboardWillHide(notification: NSNotification) {
    currentKeyboardHeight = 0
    animateLayout()
  }
  
  private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
}