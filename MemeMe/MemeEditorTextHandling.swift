//
//  MemeEditorTextHandling.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

extension MemeEditorViewController {
  func keyboardWillShow(notification: NSNotification) {
    currentKeyboardHeight = getKeyboardHeight(notification)
    animateLayout()
  }
  
  func keyboardWillHide(notification: NSNotification) {
    currentKeyboardHeight = 0
    animateLayout()
  }
  
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
    manageButtonState()
    self.showShareMemeIndicatorDelayed()
  }

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
  
  private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  

}